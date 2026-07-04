#!/usr/bin/env bash
#
# delegate_agents - DAG-based task delegation with per-provider slot pools.
# macOS-compatible: avoids Bash 4 associative arrays and GNU-only wait -n.
#
# Usage: scripts/delegate_agents.sh [--validate] <tasks_folder>
#
# --validate: run the preflight checks (task files, provider functions, dep
# references, duplicate ids, cycles) and exit without starting any agent.
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
# Resume: status=completed, status=completed_with_concerns, and reviewer
# status="blocked (reported)" are preserved. A preserved blocked review can
# unblock its paired fix-* task. Delete an agent's status file to force a re-run.

set -o pipefail

VALIDATE_ONLY=0
if [ "${1:-}" = "--validate" ]; then
  VALIDATE_ONLY=1
  shift
fi

if [ $# -lt 1 ]; then
  echo "Usage: $0 [--validate] <tasks_folder>" >&2
  exit 1
fi

TASKS_FOLDER="$1"
RESULT_FOLDER="$TASKS_FOLDER/results"
COMMON_UNDERSTANDING="$TASKS_FOLDER/common-understanding.md"
PIPELINE_CONF="$TASKS_FOLDER/pipeline.conf"
THINKING_LEVEL="${THINKING_LEVEL:-off}"
PI_SESSION_PREFIX="${PI_SESSION_PREFIX:-$(basename "$TASKS_FOLDER")}"

PIPELINE=()
SLOTS=()
THINKING_OVERRIDES=()
PROVIDERS=()
RUNNING_PIDS=()
RUNNING_IDS=()
# Sequential mode default: derived from agent-*.md files (alphabetical) unless
# pipeline.conf defines SEQUENTIAL_AGENTS explicitly.
SEQUENTIAL_AGENTS=()

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

if [ "$MODE" = "sequential" ] && [ ${#SEQUENTIAL_AGENTS[@]} -eq 0 ]; then
  for _task_file in "$TASKS_FOLDER"/agent-*.md; do
    [ -f "$_task_file" ] || continue
    _id=$(basename "$_task_file")
    _id="${_id#agent-}"
    _id="${_id%.md}"
    SEQUENTIAL_AGENTS=("${SEQUENTIAL_AGENTS[@]}" "$_id")
  done
fi

AGENT_TIMEOUT_SEC="${AGENT_TIMEOUT_SEC:-900}"
REVIEWER_TIMEOUT_SEC="${REVIEWER_TIMEOUT_SEC:-480}"
TOTAL_TIMEOUT_SEC="${TOTAL_TIMEOUT_SEC:-3600}"

if [ "$VALIDATE_ONLY" != 1 ]; then
  mkdir -p "$RESULT_FOLDER"
fi
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
  local line stripped
  if [ ! -f "$report_file" ]; then
    echo ""
    return 0
  fi
  while IFS= read -r line; do
    # Strip leading whitespace and markdown header markers so both
    # "STATUS: DONE" and "## STATUS: DONE" (and "# STATUS: DONE") match.
    stripped="${line#"${line%%[![:space:]#]*}"}"
    case "$stripped" in
    STATUS:*)
      trim_status "${stripped#STATUS:}"
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

is_fix_for_review() {
  local candidate="$1"
  local dep="$2"
  case "$candidate:$dep" in
  fix-*:karen-*) [ "${candidate#fix-}" = "${dep#karen-}" ] ;;
  *) return 1 ;;
  esac
}

status_satisfies_dependency_for() {
  local candidate="$1"
  local dep="$2"
  local status="$3"
  case "$status" in
  completed) return 0 ;;
  completed_with_concerns) [ "${STRICT_CONCERNS:-0}" != "1" ] ;;
  blocked\ \(reported\)) is_fix_for_review "$candidate" "$dep" ;;
  *) return 1 ;;
  esac
}

status_blocks_dependent() {
  local candidate="$1"
  local dep="$2"
  local status="$3"
  case "$status" in
  failed* | timed_out* | missing | needs_context*) return 0 ;;
  blocked*) ! is_fix_for_review "$candidate" "$dep" ;;
  completed_with_concerns) [ "${STRICT_CONCERNS:-0}" = "1" ] ;;
  *) return 1 ;;
  esac
}

fix_for_review() {
  local review_id="$1"
  case "$review_id" in
  karen-*) echo "fix-${review_id#karen-}" ;;
  *) echo "" ;;
  esac
}

status_exit_code() {
  case "$1" in
  completed) echo 0 ;;
  completed_with_concerns) echo 2 ;;
  *) echo 1 ;;
  esac
}

status_exit_code_for() {
  local agent_id="$1"
  local status="$2"
  local fix_id fix_status
  if [ "$status" = "blocked (reported)" ]; then
    fix_id=$(fix_for_review "$agent_id")
    if [ -n "$fix_id" ] && agent_exists "$fix_id"; then
      fix_status=$(status_of "$fix_id")
      case "$fix_status" in
      completed)
        echo 0
        return 0
        ;;
      completed_with_concerns)
        echo 2
        return 0
        ;;
      esac
    fi
  fi
  status_exit_code "$status"
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

  if [ -f "$status_file" ]; then
    case "$(cat "$status_file")" in
    completed | completed_with_concerns) return 0 ;;
    esac
  fi

  echo "running" >"$status_file"
  mkdir -p "$result_subdir"

  local prompt
  prompt=$(
    cat <<EOF
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
  export AGENT_ID="$agent_id"
  export PI_SESSION_PREFIX="${PI_SESSION_PREFIX:-$(basename "$TASKS_FOLDER")}"
  export PI_SESSION_NAME="${PI_SESSION_PREFIX}-${AGENT_ID}"

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
  r* | karen-*) echo "$REVIEWER_TIMEOUT_SEC" ;;
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
    completed | completed_with_concerns | blocked\ \(reported\)) : ;;
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
        if status_blocks_dependent "$id" "$dep" "$dep_status"; then
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
        if ! status_satisfies_dependency_for "$id" "$dep" "$(status_of "$dep")"; then
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
    status_code=$(status_exit_code_for "$id" "$status")
    if [ "$status_code" -eq 1 ]; then
      exit_code=1
    elif [ "$status_code" -eq 2 ] && [ "$exit_code" -eq 0 ]; then
      exit_code=2
    fi
  done
  return "$exit_code"
}

preflight_dag() {
  local errors=0 entry id deps dep provider seen=" " resolved=" " progress unresolved
  local task_file base tid found

  for entry in "${PIPELINE[@]}"; do
    id="${entry%%:*}"
    case "$seen" in
    *" $id "*)
      echo "PREFLIGHT: duplicate pipeline id '$id'" >&2
      errors=1
      ;;
    esac
    seen="$seen$id "

    if [ ! -f "$TASKS_FOLDER/agent-$id.md" ]; then
      echo "PREFLIGHT: missing task file agent-$id.md for pipeline id '$id'" >&2
      errors=1
    fi

    provider=$(provider_for "$id")
    if ! declare -F "provider_$provider" >/dev/null 2>&1; then
      echo "PREFLIGHT: missing function provider_$provider (agent '$id')" >&2
      errors=1
    fi

    deps=$(deps_for "$id")
    for dep in $deps; do
      if ! agent_exists "$dep"; then
        echo "PREFLIGHT: agent '$id' depends on unknown id '$dep'" >&2
        errors=1
      fi
    done
  done

  # Task files present but absent from the pipeline (warning only).
  for task_file in "$TASKS_FOLDER"/agent-*.md; do
    [ -f "$task_file" ] || continue
    base=$(basename "$task_file")
    tid="${base#agent-}"
    tid="${tid%.md}"
    if ! agent_exists "$tid"; then
      echo "PREFLIGHT: warning: $base exists but '$tid' is not in PIPELINE" >&2
    fi
  done

  # Cycle detection: repeatedly resolve ids whose deps are all resolved.
  progress=1
  while [ "$progress" = 1 ]; do
    progress=0
    for entry in "${PIPELINE[@]}"; do
      id="${entry%%:*}"
      case "$resolved" in *" $id "*) continue ;; esac
      deps=$(deps_for "$id")
      found=0
      for dep in $deps; do
        agent_exists "$dep" || continue
        case "$resolved" in
        *" $dep "*) : ;;
        *)
          found=1
          break
          ;;
        esac
      done
      if [ "$found" = 0 ]; then
        resolved="$resolved $id "
        progress=1
      fi
    done
  done
  unresolved=""
  for entry in "${PIPELINE[@]}"; do
    id="${entry%%:*}"
    case "$resolved" in *" $id "*) continue ;; esac
    unresolved="$unresolved $id"
  done
  if [ -n "$unresolved" ]; then
    echo "PREFLIGHT: dependency cycle involving:$unresolved" >&2
    errors=1
  fi

  return "$errors"
}

preflight_sequential() {
  local errors=0 agent_id
  if [ ${#SEQUENTIAL_AGENTS[@]} -eq 0 ]; then
    echo "PREFLIGHT: no agent-*.md files found in $TASKS_FOLDER" >&2
    errors=1
  fi
  for agent_id in "${SEQUENTIAL_AGENTS[@]}"; do
    if [ ! -f "$TASKS_FOLDER/agent-$agent_id.md" ]; then
      echo "PREFLIGHT: missing task file agent-$agent_id.md" >&2
      errors=1
    fi
  done
  return "$errors"
}

if [ "$MODE" = "dag" ]; then
  if ! preflight_dag; then
    echo "PREFLIGHT FAILED: fix pipeline.conf / task files before running." >&2
    exit 3
  fi
else
  if ! preflight_sequential; then
    echo "PREFLIGHT FAILED: fix task files before running." >&2
    exit 3
  fi
fi

if [ "$VALIDATE_ONLY" = 1 ]; then
  echo "Preflight OK: mode=$MODE, agents=$([ "$MODE" = "dag" ] && echo "${#PIPELINE[@]}" || echo "${#SEQUENTIAL_AGENTS[@]}")"
  exit 0
fi

echo "Tasks folder : $TASKS_FOLDER"
echo "Results in   : $RESULT_FOLDER"
echo "Per-developer: ${AGENT_TIMEOUT_SEC}s"
echo "Per-reviewer : ${REVIEWER_TIMEOUT_SEC}s"
echo "Total        : ${TOTAL_TIMEOUT_SEC}s"
echo

exit_code=0
case "$MODE" in
dag) run_dag || exit_code=$? ;;
sequential)
  export_provider_functions
  run_sequential || exit_code=$?
  ;;
*)
  echo "ERROR: unknown mode $MODE" >&2
  exit 1
  ;;
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
