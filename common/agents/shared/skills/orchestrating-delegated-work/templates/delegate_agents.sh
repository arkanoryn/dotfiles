#!/usr/bin/env bash
#
# delegate_agents - DAG-based task delegation with per-provider slot pools.
# macOS-compatible: avoids Bash 4 associative arrays and GNU-only wait -n.
#
# Usage: scripts/delegate_agents.sh <tasks_folder>
#
# DAG mode: if <tasks_folder>/pipeline.conf exists, source it. The file should
# define provider_<name>() functions plus Bash-3-compatible arrays:
#   SLOTS=("copilot=3")
#   THINKING_OVERRIDES=("r05=high")
#   PIPELINE=("00:copilot:" "01:copilot:00")
#
# Sequential mode: if no pipeline.conf exists, run SEQUENTIAL_AGENTS in order.
#
# Review gates:
#   DONE                -> completed
#   DONE_WITH_CONCERNS -> completed_with_concerns; dependents continue unless STRICT_CONCERNS=1; final exit 2
#   NEEDS_CONTEXT      -> needs_context; dependents blocked; final exit 1
#   BLOCKED            -> blocked (reported); dependents blocked; final exit 1
#
# Resume: only status=completed is skipped. Delete an agent's status file to
# force a re-run.

set -o pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <tasks_folder>" >&2
  exit 1
fi

TASKS_FOLDER="$1"
RESULT_FOLDER="$TASKS_FOLDER/results"
COMMON_UNDERSTANDING="$TASKS_FOLDER/common-understanding.md"
PIPELINE_CONF="$TASKS_FOLDER/pipeline.conf"
AGENT_TIMEOUT_SEC="${AGENT_TIMEOUT_SEC:-900}"
REVIEWER_TIMEOUT_SEC="${REVIEWER_TIMEOUT_SEC:-480}"
TOTAL_TIMEOUT_SEC="${TOTAL_TIMEOUT_SEC:-3600}"
THINKING_LEVEL="${THINKING_LEVEL:-off}"

PIPELINE=()
SLOTS=()
THINKING_OVERRIDES=()
PROVIDERS=()
RUNNING_PIDS=()
RUNNING_IDS=()
SEQUENTIAL_AGENTS=(00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 r15 17 18 r18 20 21 22 23 24 25 26 27a 27b 27c 27d 27e 27f 27g r27 28 29 30 31 32 33 34 35 36 37 38)

if [ ! -d "$TASKS_FOLDER" ]; then
  echo "Error: tasks folder not found: $TASKS_FOLDER" >&2
  exit 1
fi

if [ ! -f "$COMMON_UNDERSTANDING" ]; then
  echo "Error: common-understanding.md not found in $TASKS_FOLDER" >&2
  exit 1
fi

if [ -f "$PIPELINE_CONF" ]; then
  # shellcheck disable=SC1090
  source "$PIPELINE_CONF"
  if [ ${#PIPELINE[@]} -gt 0 ]; then
    MODE="dag"
  else
    MODE="sequential"
  fi
else
  MODE="sequential"
fi

mkdir -p "$RESULT_FOLDER"
START_TIME=$(date +%s)

elapsed() {
  echo $(($(date +%s) - START_TIME))
}

cleanup() {
  local exit_code="${1:-130}"
  echo "Cleanup: killing running agents" >&2
  local pid
  for pid in "${RUNNING_PIDS[@]}"; do
    if kill -0 "$pid" 2>/dev/null; then
      kill -TERM "$pid" 2>/dev/null || true
    fi
  done
  sleep 1
  for pid in "${RUNNING_PIDS[@]}"; do
    if kill -0 "$pid" 2>/dev/null; then
      kill -KILL "$pid" 2>/dev/null || true
    fi
  done
  exit "$exit_code"
}
trap 'cleanup 130' INT TERM

check_total_timeout() {
  local e
  e=$(elapsed)
  if [ "$e" -ge "$TOTAL_TIMEOUT_SEC" ]; then
    echo "TOTAL TIMEOUT: ${e}s >= ${TOTAL_TIMEOUT_SEC}s" >&2
    echo "killed" >"$RESULT_FOLDER/_script.status"
    cleanup 124
  fi
}

remaining_for_next_agent() {
  local remaining=$((TOTAL_TIMEOUT_SEC - $(elapsed)))
  if [ "$remaining" -lt 1 ]; then
    echo 0
  else
    echo "$remaining"
  fi
}

trim_status() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  echo "$value"
}

agent_exists() {
  local agent_id="$1"
  local entry id
  for entry in "${PIPELINE[@]}"; do
    id="${entry%%:*}"
    if [ "$id" = "$agent_id" ]; then
      return 0
    fi
  done
  return 1
}

entry_for() {
  local agent_id="$1"
  local entry id
  for entry in "${PIPELINE[@]}"; do
    id="${entry%%:*}"
    if [ "$id" = "$agent_id" ]; then
      echo "$entry"
      return 0
    fi
  done
  return 1
}

provider_for() {
  local agent_id="$1"
  local entry rest
  entry=$(entry_for "$agent_id") || return 1
  rest="${entry#*:}"
  echo "${rest%%:*}"
}

deps_for() {
  local agent_id="$1"
  local entry rest
  entry=$(entry_for "$agent_id") || return 1
  rest="${entry#*:}"
  echo "${rest#*:}"
}

status_file_for() {
  echo "$RESULT_FOLDER/$1.status"
}

status_of() {
  local agent_id="$1"
  local file
  if [ "$MODE" = "dag" ] && ! agent_exists "$agent_id"; then
    echo "missing"
    return 0
  fi
  file=$(status_file_for "$agent_id")
  if [ -f "$file" ]; then
    cat "$file"
  else
    echo "pending"
  fi
}

set_status() {
  local agent_id="$1"
  local status="$2"
  echo "$status" >"$(status_file_for "$agent_id")"
}

extract_report_status() {
  local report_file="$1"
  local line
  if [ ! -f "$report_file" ]; then
    echo ""
    return 0
  fi
  while IFS= read -r line; do
    case "$line" in
    STATUS:*)
      trim_status "${line#STATUS:}"
      return 0
      ;;
    esac
  done <"$report_file"
  echo ""
}

status_from_report() {
  local report_file="$1"
  local reported_status
  if [ ! -f "$report_file" ]; then
    echo "failed (missing report.md)"
    return 0
  fi
  reported_status=$(extract_report_status "$report_file")
  case "$reported_status" in
  DONE) echo "completed" ;;
  DONE_WITH_CONCERNS) echo "completed_with_concerns" ;;
  NEEDS_CONTEXT) echo "needs_context" ;;
  BLOCKED) echo "blocked (reported)" ;;
  "") echo "failed (missing STATUS in report.md)" ;;
  *) echo "failed (invalid report STATUS: $reported_status)" ;;
  esac
}

status_satisfies_dependency() {
  case "$1" in
  completed) return 0 ;;
  completed_with_concerns) [ "${STRICT_CONCERNS:-0}" != "1" ] ;;
  *) return 1 ;;
  esac
}

status_blocks_dependents() {
  case "$1" in
  failed* | timed_out* | missing | blocked* | needs_context*) return 0 ;;
  completed_with_concerns) [ "${STRICT_CONCERNS:-0}" = "1" ] ;;
  *) return 1 ;;
  esac
}

status_exit_code() {
  case "$1" in
  completed) echo 0 ;;
  completed_with_concerns) echo 2 ;;
  *) echo 1 ;;
  esac
}

thinking_level_for() {
  local agent_id="$1"
  local item key value
  for item in "${THINKING_OVERRIDES[@]}"; do
    key="${item%%=*}"
    value="${item#*=}"
    if [ "$key" = "$agent_id" ]; then
      echo "$value"
      return 0
    fi
  done
  echo "${THINKING_LEVEL:-medium}"
}

slot_for() {
  local provider="$1"
  local item key value
  for item in "${SLOTS[@]}"; do
    key="${item%%=*}"
    value="${item#*=}"
    if [ "$key" = "$provider" ]; then
      echo "$value"
      return 0
    fi
  done
  echo 1
}

add_provider_once() {
  local provider="$1"
  local existing
  for existing in "${PROVIDERS[@]}"; do
    if [ "$existing" = "$provider" ]; then
      return 0
    fi
  done
  PROVIDERS=("${PROVIDERS[@]}" "$provider")
}

initialize_providers() {
  local item entry rest provider
  for item in "${SLOTS[@]}"; do
    add_provider_once "${item%%=*}"
  done
  for entry in "${PIPELINE[@]}"; do
    rest="${entry#*:}"
    provider="${rest%%:*}"
    add_provider_once "$provider"
  done
}

export_provider_functions() {
  local fn
  for fn in $(declare -F | awk '{print $3}' | grep '^provider_' || true); do
    export -f "$fn"
  done
}

run_with_timeout() {
  local seconds="$1"
  shift

  if command -v timeout >/dev/null 2>&1; then
    timeout "$seconds" "$@"
    return $?
  fi

  if command -v gtimeout >/dev/null 2>&1; then
    gtimeout "$seconds" "$@"
    return $?
  fi

  local marker="$RESULT_FOLDER/.timeout.$$.$RANDOM"
  local cmd_pid watchdog_pid exit_code
  "$@" &
  cmd_pid=$!
  (
    sleep "$seconds"
    if kill -0 "$cmd_pid" 2>/dev/null; then
      echo timeout >"$marker"
      kill -TERM "$cmd_pid" 2>/dev/null || true
      sleep 1
      kill -KILL "$cmd_pid" 2>/dev/null || true
    fi
  ) &
  watchdog_pid=$!

  wait "$cmd_pid"
  exit_code=$?
  kill "$watchdog_pid" 2>/dev/null || true
  wait "$watchdog_pid" 2>/dev/null || true

  if [ -f "$marker" ]; then
    rm -f "$marker"
    return 124
  fi
  return "$exit_code"
}

run_agent() {
  local agent_id="$1"
  local effective_timeout="$2"
  local task_file="$TASKS_FOLDER/agent-$agent_id.md"
  local status_file="$RESULT_FOLDER/$agent_id.status"
  local log_file="$RESULT_FOLDER/$agent_id.log"
  local result_subdir="$RESULT_FOLDER/$agent_id"

  if [ ! -f "$task_file" ]; then
    echo "missing" >"$status_file"
    return 0
  fi

  if [ -f "$status_file" ] && [ "$(cat "$status_file")" = "completed" ]; then
    return 0
  fi

  echo "running" >"$status_file"
  mkdir -p "$result_subdir"

  local prompt
  prompt=$(cat <<EOF
read the common-understanding and the task file. then implement the task.

once you are done:
- write down your results in $result_subdir/
- include a report.md inside $result_subdir/ with the exact format from common-understanding.md
- send a desktop notification if practical:
  - macOS: \`osascript -e 'display notification "{message}" with title "Pi" subtitle "{Status}"'\`
  - Linux: \`notify-send --app-name "Pi" "{Status}" "{message}"\`
EOF
)

  local provider provider_fn level exit_code
  if [ "$MODE" = "dag" ]; then
    provider=$(provider_for "$agent_id" || echo "minimax")
  else
    provider="minimax"
  fi
  provider_fn="provider_$provider"
  level=$(thinking_level_for "$agent_id")
  export THINKING_LEVEL="$level"

  if declare -F "$provider_fn" >/dev/null 2>&1; then
    if run_with_timeout "$effective_timeout" bash -c "$provider_fn \"\$@\"" _ \
      "$task_file" "$COMMON_UNDERSTANDING" "$prompt" \
      >"$log_file" 2>&1; then
      status_from_report "$result_subdir/report.md" >"$status_file"
    else
      exit_code=$?
      if [ "$exit_code" -eq 124 ]; then
        echo "timed_out (${effective_timeout}s)" >"$status_file"
      else
        echo "failed ($exit_code)" >"$status_file"
      fi
    fi
  else
    echo "failed (missing provider function: $provider_fn)" >"$status_file"
  fi
}

base_timeout_for() {
  case "$1" in
  r*) echo "$REVIEWER_TIMEOUT_SEC" ;;
  *) echo "$AGENT_TIMEOUT_SEC" ;;
  esac
}

effective_timeout_for() {
  local agent_id="$1"
  local base remaining
  base=$(base_timeout_for "$agent_id")
  remaining=$(remaining_for_next_agent)
  if [ "$remaining" -lt "$base" ]; then
    echo "$remaining"
  else
    echo "$base"
  fi
}

is_job_running() {
  local pid="$1"
  jobs -pr | grep -qx "$pid"
}

update_running_agents() {
  local new_pids=()
  local new_ids=()
  local i pid agent_id status
  i=0
  while [ "$i" -lt "${#RUNNING_PIDS[@]}" ]; do
    pid="${RUNNING_PIDS[$i]}"
    agent_id="${RUNNING_IDS[$i]}"
    if is_job_running "$pid"; then
      new_pids=("${new_pids[@]}" "$pid")
      new_ids=("${new_ids[@]}" "$agent_id")
    else
      wait "$pid" 2>/dev/null || true
      status=$(status_of "$agent_id")
      echo "[$(date +%H:%M:%S)] $agent_id -> $status (elapsed: $(elapsed)s)"
    fi
    i=$((i + 1))
  done
  RUNNING_PIDS=("${new_pids[@]}")
  RUNNING_IDS=("${new_ids[@]}")
}

in_flight_for_provider() {
  local provider="$1"
  local count=0
  local agent_id agent_provider
  for agent_id in "${RUNNING_IDS[@]}"; do
    agent_provider=$(provider_for "$agent_id" || echo "")
    if [ "$agent_provider" = "$provider" ]; then
      count=$((count + 1))
    fi
  done
  echo "$count"
}

run_sequential() {
  echo "Mode: sequential"
  echo "Agents: ${#SEQUENTIAL_AGENTS[@]}"
  echo

  local agent_id effective_timeout status exit_code status_code
  for agent_id in "${SEQUENTIAL_AGENTS[@]}"; do
    check_total_timeout
    effective_timeout=$(effective_timeout_for "$agent_id")
    if [ "$effective_timeout" -lt 1 ]; then
      echo "TOTAL TIMEOUT: cannot start $agent_id, no time remaining" >&2
      break
    fi
    echo "[$(date +%H:%M:%S)] running $agent_id (elapsed: $(elapsed)s, timeout: ${effective_timeout}s)"
    run_agent "$agent_id" "$effective_timeout"
    status=$(status_of "$agent_id")
    echo "[$(date +%H:%M:%S)] $agent_id -> $status (elapsed: $(elapsed)s)"
  done

  echo
  echo "Summary:"
  exit_code=0
  for agent_id in "${SEQUENTIAL_AGENTS[@]}"; do
    status=$(status_of "$agent_id")
    echo "  $agent_id: $status"
    status_code=$(status_exit_code "$status")
    if [ "$status_code" -eq 1 ]; then
      exit_code=1
    elif [ "$status_code" -eq 2 ] && [ "$exit_code" -eq 0 ]; then
      exit_code=2
    fi
  done
  return "$exit_code"
}

initialize_dag_statuses() {
  local entry id status
  for entry in "${PIPELINE[@]}"; do
    id="${entry%%:*}"
    status=$(status_of "$id")
    case "$status" in
    completed) : ;;
    *) set_status "$id" "pending" ;;
    esac
  done
}

mark_blocked_agents() {
  local entry id deps dep dep_status
  for entry in "${PIPELINE[@]}"; do
    id="${entry%%:*}"
    if [ "$(status_of "$id")" = "pending" ]; then
      deps=$(deps_for "$id")
      for dep in $deps; do
        dep_status=$(status_of "$dep")
        if status_blocks_dependents "$dep_status"; then
          set_status "$id" "blocked (dep $dep $dep_status)"
          break
        fi
      done
    fi
  done
}

build_ready_queue() {
  READY=()
  local entry id deps dep all_done
  for entry in "${PIPELINE[@]}"; do
    id="${entry%%:*}"
    if [ "$(status_of "$id")" = "pending" ]; then
      deps=$(deps_for "$id")
      all_done=true
      for dep in $deps; do
        if ! status_satisfies_dependency "$(status_of "$dep")"; then
          all_done=false
          break
        fi
      done
      if [ "$all_done" = true ]; then
        READY=("${READY[@]}" "$id")
      fi
    fi
  done
}

start_ready_agents() {
  local provider slot_count in_flight free candidate candidate_provider timeout new_ready=()
  for provider in "${PROVIDERS[@]}"; do
    slot_count=$(slot_for "$provider")
    in_flight=$(in_flight_for_provider "$provider")
    free=$((slot_count - in_flight))
    if [ "$free" -lt 0 ]; then
      free=0
    fi

    new_ready=()
    for candidate in "${READY[@]}"; do
      candidate_provider=$(provider_for "$candidate" || echo "")
      if [ "$free" -gt 0 ] && [ "$candidate_provider" = "$provider" ]; then
        timeout=$(effective_timeout_for "$candidate")
        if [ "$timeout" -lt 1 ]; then
          echo "TOTAL TIMEOUT: cannot start $candidate, no time remaining" >&2
          set_status "$candidate" "timed_out (0s)"
          continue
        fi
        run_agent "$candidate" "$timeout" &
        RUNNING_PIDS=("${RUNNING_PIDS[@]}" "$!")
        RUNNING_IDS=("${RUNNING_IDS[@]}" "$candidate")
        free=$((free - 1))
        echo "[$(date +%H:%M:%S)] starting $candidate on $provider (elapsed: $(elapsed)s, timeout: ${timeout}s)"
      else
        new_ready=("${new_ready[@]}" "$candidate")
      fi
    done
    READY=("${new_ready[@]}")
  done
}

pending_count() {
  local count=0 entry id
  for entry in "${PIPELINE[@]}"; do
    id="${entry%%:*}"
    if [ "$(status_of "$id")" = "pending" ]; then
      count=$((count + 1))
    fi
  done
  echo "$count"
}

run_dag() {
  initialize_providers
  export_provider_functions
  initialize_dag_statuses

  echo "Mode: DAG (continuous scheduler with per-provider slot pools)"
  echo "Pipeline: ${#PIPELINE[@]} agents"
  echo "Slots:"
  local provider
  for provider in "${PROVIDERS[@]}"; do
    echo "  $provider: $(slot_for "$provider")"
  done
  echo

  local pending status_code exit_code entry id status
  while true; do
    check_total_timeout
    update_running_agents
    mark_blocked_agents
    build_ready_queue
    start_ready_agents

    if [ ${#RUNNING_PIDS[@]} -eq 0 ]; then
      if [ ${#READY[@]} -eq 0 ]; then
        pending=$(pending_count)
        if [ "$pending" -gt 0 ]; then
          echo "DEADLOCK: $pending pending agents with unsatisfied deps" >&2
        fi
        break
      fi
      echo "ERROR: ready non-empty but no assignment" >&2
      break
    fi

    sleep 1
  done

  echo
  echo "DAG summary (elapsed: $(elapsed)s):"
  exit_code=0
  for entry in "${PIPELINE[@]}"; do
    id="${entry%%:*}"
    status=$(status_of "$id")
    echo "  $id: $status"
    status_code=$(status_exit_code "$status")
    if [ "$status_code" -eq 1 ]; then
      exit_code=1
    elif [ "$status_code" -eq 2 ] && [ "$exit_code" -eq 0 ]; then
      exit_code=2
    fi
  done
  return "$exit_code"
}

echo "Tasks folder : $TASKS_FOLDER"
echo "Results in   : $RESULT_FOLDER"
echo "Per-developer: ${AGENT_TIMEOUT_SEC}s"
echo "Per-reviewer : ${REVIEWER_TIMEOUT_SEC}s"
echo "Total        : ${TOTAL_TIMEOUT_SEC}s"
echo

exit_code=0
case "$MODE" in
dag) run_dag || exit_code=$? ;;
sequential) export_provider_functions; run_sequential || exit_code=$? ;;
*) echo "ERROR: unknown mode $MODE" >&2; exit 1 ;;
esac

echo
if [ "$exit_code" -eq 0 ]; then
  echo "All done in $(elapsed)s."
elif [ "$exit_code" -eq 2 ]; then
  echo "Done with concerns in $(elapsed)s." >&2
else
  echo "Finished with failures in $(elapsed)s." >&2
fi

exit "$exit_code"
