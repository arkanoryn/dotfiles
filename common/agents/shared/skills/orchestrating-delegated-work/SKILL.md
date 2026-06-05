---
name: orchestrating-delegated-work
description: Use after brainstorming, when ready to split a feature into micro-tasks for `scripts/delegate_agents.sh` (DAG-based). Produces a `.agents/plans/<branch>/<phase>-execution/` folder with `common-understanding.md`, `pipeline.conf`, and one `agent-<NN>.md` per task.
---

# Orchestrating Delegated Work

## When to Use This Skill

You are an orchestrator preparing an execution breakdown for `scripts/delegate_agents.sh`. The user has finished brainstorming and produced a spec (a canonical doc at `.agents/roadmap/<domain>.md` or `.agents/docs/<domain>/overview.md`).

Your job: create a self-contained execution folder that another agent (or the user) can hand to the script and run.

**This skill produces everything inline. Future agents invoking this skill may not have access to prior examples, so all templates and rules are embedded in this file.**

---

## What This Skill Produces

A folder at `.agents/plans/<branch>/<phase>-execution/` (or `.agents/plans/<branch>-execution/` if there is no phase) containing:

| File                                              | Purpose                                                                 |
| ------------------------------------------------- | ----------------------------------------------------------------------- |
| `<phase>.md` (or `<branch>.md`)                   | The explanation doc: what this phase does, decisions, scope, files      |
| `pipeline.conf`                                   | The DAG: provider functions, slot pool, agent → provider → deps mapping |
| `common-understanding.md`                         | Shared context every agent reads first                                  |
| `agent-<NN>.md`, `agent-<NNa>.md`, `agent-rNN.md` | One micro-task per file                                                 |
| `results/`                                        | Created at runtime by the script; do not pre-create                     |

---

## Step 1: Detect Branch and Phase

Determine the values for `<branch>` and `<phase>` in the paths.

```bash
# Branch: try git first
git -C <project_root> rev-parse --abbrev-ref HEAD 2>/dev/null
# Returns: provider / feature-foo / main / etc.
# Or returns "HEAD" (detached) or fails — fall through to ask
```

If git is unavailable, returns "HEAD" (detached), or the user is on a non-git project, **ask the user**:

> "What branch are we on? (the script will use this as the folder name under `.agents/plans/`)"

Then ask:

> "What phase number or name is this? Examples: `1`, `2`, `phase-1`, `phase-2`, `setup`, `crud`, `ui`. Or say 'no phase' if this is top-level work."

Substitute the answers into the path placeholders below. The convention:

- If phase exists: `.agents/plans/<branch>/<phase>.md` and `.agents/plans/<branch>/<phase>-execution/`
- If no phase: `.agents/plans/<branch>.md` and `.agents/plans/<branch>-execution/`

Throughout this document, `<phase>` and `<branch>` are placeholders. Substitute your detected values in the actual files.

---

## Step 2: The Explanation Doc

Create `<phase>.md` (or `<branch>.md` if no phase). This is the "what" doc — what this phase accomplishes, what decisions it captures, what's out of scope.

### Template (copy and fill)

```markdown
# <Feature> — Phase <N> Plan

> **Date**: YYYY-MM-DD
> **Branch**: <branch>
> **Phase**: <N or "none">
> **Status**: Ready for execution

## 🎯 Mission

<1-2 sentences. The observable outcome. What is true when this phase is done.>

## 🏗️ Architecture

<2-3 sentences about the approach. Reference relevant ADRs, data-structures.md sections, related docs.>

## 🔑 Key Decisions

| Decision   | Rationale | Reference         |
| ---------- | --------- | ----------------- |
| <decision> | <why>     | <ADR or doc link> |
| ...        | ...       | ...               |

## 📁 Files to Create / Modify

| File     | Action | Notes        |
| -------- | ------ | ------------ |
| `<path>` | create | <short note> |
| `<path>` | modify | <short note> |
| ...      | ...    | ...          |

## 🚫 Out of Scope (Phase <N> explicit non-goals)

|                 | When        |
| --------------- | ----------- |
| <deferred item> | Phase <N+1> |
| <deferred item> | Later       |
| <deferred item> | Not planned |

## ✅ Acceptance Criteria

- [ ] <Observable behavior or test>
- [ ] <Another criterion>
- [ ] All tasks complete with status `completed` in `results/`
- [ ] All validation commands pass (cargo, yarn, etc.)
```

---

## Step 3: The Pipeline.conf

Create `pipeline.conf` in the execution folder. The script auto-detects DAG mode when this file exists.

### Provider Convention (project-wide)

Standard convention for this project (and most agentic-work projects):

| Role                                  | Provider      | Use for                                                                                                       |
| ------------------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------- |
| **Coding (backend / Rust / systems)** | `minimax`     | Type correctness, lifetimes, compilation, integration. Where precision matters.                               |
| **Coding (frontend / TS / Svelte)**   | `mistral`     | Different cognitive load, different strengths. UI work, types, components.                                    |
| **Reviewer / Fixer**                  | `gpt` (codex) | Different model = different blind spots. The reviewer must NOT be the same model as the developer it reviews. |

**Rule of thumb for distributing coding agents:**

- Both `minimax` and `mistral` should be exercised in any non-trivial pipeline. Don't put everything on one provider.
- A common pattern: backend on `minimax`, frontend on `mistral`, reviewers on `gpt`. Adjust per phase.
- If the phase is pure-Rust, distribute `minimax`/`mistral` by task type or area (e.g., data model on one, commands on the other). Don't use `gpt` for coding — `gpt` is for reviews.

**Slot pool implication:** with 1 slot per provider and all 3 providers used, you get up to 3 agents in parallel. The 2 coding providers can run simultaneously when their DAG branches are independent.

### Format (copy and adapt)

```bash
# pipeline.conf

# ---------------------------------------------------------------------------
# Provider functions
# ---------------------------------------------------------------------------
# Each function is the "how do I invoke this provider" recipe. It receives
# 3 args from the script: <task_file> <common_understanding_file> <prompt>.
# The function body should NOT wrap in `timeout` — the script handles that.
# Use the right prompt format for the tool (-p for pi, custom for others).

# minimax via pi (accepts --thinking; reads $THINKING_LEVEL)
provider_minimax() {
  pi --provider minimax --model minimax-m3 \
    --thinking "${THINKING_LEVEL:-medium}" \
    -p "@$1" -p "@$2" -p "$3"
}

# mistral via vibe (thinking level set in the app, not via flag)
provider_mistral() {
  vibe -p "$3"
}

# gpt-5.5 reviewer via pi
provider_gpt() {
  pi --provider openai-codex --model gpt-5.5 \
    --thinking "${THINKING_LEVEL:-medium}" \
    -p "@$1" -p "@$2" -p "$3"
}

# ---------------------------------------------------------------------------
# Slot pool: max concurrent agents per provider
# ---------------------------------------------------------------------------
# Each provider has its own pool. The script starts the next ready agent of
# a provider as soon as a slot opens. Default: 1 per provider.
# Common pattern: 1 minimax + 1 mistral + 1 gpt = 3 agents max in parallel.

SLOTS=(
  [minimax]=1
  [mistral]=1
  [gpt]=1
)

# Thinking level: the script exports $THINKING_LEVEL for each agent
# invocation. Provider functions that support a thinking flag (e.g.,
# `pi --thinking`) should read it. Default: medium. Override per-agent
# via THINKING_OVERRIDES below for reviewers and complex refactors.
THINKING_LEVEL=medium

# Per-agent overrides. Map of agent_id → "low" | "medium" | "high".
# Common pattern: medium for the bulk, high for reviewers + cross-cutting
# refactors (e.g., a refactor that touches 4+ files), low for trivial
# edits if the tool supports it.
THINKING_OVERRIDES=(
  [r15]=high
  [r18]=high
  [r27]=high
)

# ---------------------------------------------------------------------------
# Pipeline: the DAG
# ---------------------------------------------------------------------------
# Each entry: "<agent_id>:<provider>:<space-separated-deps>"
# Empty deps = first wave (no prerequisites).
# Deps can be any agent id, regardless of position in the array.
# The scheduler computes waves via topological sort.
# FIFO ordering within a provider is by id (lowest first).

PIPELINE=(
  "00:minimax:"
  "01:mistral:"
  "02:minimax:"
  "03:minimax:"
  "r04:gpt:00 01 02 03"
  "05:minimax:r04"
  ...
)
```

### Pipeline Rules

- Each agent has a unique id (string, conventionally 2-digit like `00`, `01`, or with letter suffix like `27a`).
- Deps are space-separated agent ids.
- Empty deps = first wave.
- The order in the array does NOT matter for execution; the scheduler sorts by the DAG. But keep it logical (e.g., setup → core → integration → polish) for readability.
- A reviewer/fixer agent's id should start with `r` (e.g., `r15`). The script auto-detects this and uses the shorter 8-min timeout.

---

## Step 4: The Common Understanding

Create `common-understanding.md`. Every agent reads this. It contains the shared contract.

### Template (copy and adapt)

````markdown
# Common Understanding — <Feature> Phase <N>

> Read this file before any `agent-<id>.md`. Shared contract for all child agents.
> Do not rely on parent chat history — assume you are a fresh session with zero context.

## 🎯 Mission

<1-2 sentences. What this phase produces.>

## 🏗️ Architecture

<Short description of the data flow / system context. Reference docs.>

### Hard Rules

<Rules that apply to every agent. Examples:>
- No `std::fs` / `tokio::fs` in domain crates; route through `crates/persistence`
- No inline comments in production code; use `///` Rustdoc
- Use `tracing` macros for logging; never `println!`
- Follow project-specific coding standards from `.agents/instructions/*.md`

## 📦 Phase Scope

<What's in scope. Reference the spec doc at `<spec path>`.>

## 🚫 Out of Scope

<What's NOT in this phase. Cross-reference the spec's "Out of scope" section.>

## 📁 File Ownership Map

<One row per agent. The agent id and the files it may edit.>

| Agent | Files owned |
| ----- | ----------- |
| 00    | `<path>`    |
| 01    | `<path>`    |
| ...   | ...         |

If your task touches a file not on your row, stop and report `BLOCKED`.

## 🛂 Validation Commands

Run the relevant one (or all) for your task. If a command cannot run, report why and give next-best evidence.

| Layer             | Command                   |
| ----------------- | ------------------------- |
| Rust compile      | `cargo check --workspace` |
| Rust tests        | `cargo test --workspace`  |
| TS / Svelte check | `yarn check`              |
| E2E (headless)    | `yarn test:e2e:browser`   |

## ⏱️ Per-Agent Timeouts

| Type           | Timeout | Env var                              | Applies to                          |
| -------------- | ------- | ------------------------------------ | ----------------------------------- |
| Developer      | 15 min  | `AGENT_TIMEOUT_SEC` (default 900)    | All `NN` and `NN[letter]` agents    |
| Reviewer/Fixer | 8 min   | `REVIEWER_TIMEOUT_SEC` (default 480) | All `rNN` agents (id ends with `r`) |
| Total script   | 60 min  | `TOTAL_TIMEOUT_SEC` (default 3600)   | The whole run                       |

If a reviewer/fixer times out, the script records `timed_out (<s>s)` and moves to the next agent. The supervisor reviews the partial fix and either patches it manually or re-runs the script (status files are preserved, so re-running picks up where it left off).

If the total timeout fires, the script kills any running agent, writes `_script.status=killed`, and exits. Re-run the same command to resume.

## 📋 Final Response Format

Every agent must end with exactly this block, written to `<results_folder>/<agent_id>/report.md` and printed to the log:

```markdown
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
CHANGED_OR_CHECKED_FILES:

- `path` — summary
  VALIDATION:
- command/evidence: result
  RISKS_OR_QUESTIONS:
- item or none
```
````

Plus send a desktop notification on completion (see "End-of-Task Notification" in each task file).

## 🛑 Stop Rules

Stop and report `BLOCKED` (do not guess) if you encounter any of:

- An unapproved product, architecture, API, security, data model, or scope decision
- A file outside your ownership row
- A spec ambiguity that has two reasonable interpretations
- A missing primitive in a downstream dependency (e.g., `crates/persistence`) that would require a large addition
- A test failure you cannot resolve within your task scope
- A surface (Tauri/Svelte/API) that doesn't match the spec

For minor ambiguities (a field name, a default value, a styling choice), pick the most reasonable option and continue; mention it in `RISKS_OR_QUESTIONS`.

## 🔐 Security Reminders

<Any project-specific security notes. E.g., "API key stored plaintext in Phase 1 per ADR-XXX; do not add encryption.">

## 🧪 Testing Conventions

- Unit tests: inline `#[cfg(test)] mod tests { ... }` in each source file
- Integration tests: `<crate>/tests/integration_test.rs`
- E2E tests: `e2e/tests/<feature>/*.spec.ts`, browser-only mode per project AGENTS.md
- Coverage target: ≥80% on critical paths
- E2E must use UI flows (`getByTestId`, `click`, `goto`) — never direct `invoke()` from the console

````

---

## Step 5: The Agent Tasks

For each unit of work, create `agent-<NN>.md`. The standard structure is below — copy this template for every agent file, fill in the placeholders.

### Agent Task Template (copy and fill for every task)

```markdown
# Agent — <role>: <one-line outcome>

## Mission

<One sentence. The observable deliverable.>

## Required Context

This task must be complete for a fresh-session child agent. Do not rely on parent chat history.

- `<path>` — <why it matters>
- `<path>` — <why it matters>

Read these skills first:
- `pi-delegation-contract` — the delegation contract format (mission, scope, ownership, validation, final response, stop rules)
- `writing-clearly-and-concisely` — clear, active-voice prose
- `writing-plans` — bite-sized task discipline (2-5 min per step)

## Scope and Ownership

You may inspect:
- `<any file or directory>`

You may edit only:
- `<exact file path>`

Do not:
- Edit other files (escalate as `BLOCKED` if you need to)
- Commit, stage, or push
- Read ignored, private, credential, secret, or `.env` files
- Widen scope or refactor unrelated code

## Task

<Detailed task with code samples or structural guidance. Be specific. Show the actual code to write or the file content to create.>

## Acceptance Criteria

- <Observable behavior or review standard>
- <Another standard>
- <A test or command that must pass>

## Validation

Run, if practical:
```bash
<command>
````

If unavailable, report why and give next-best evidence.

## Stop Rules

- See `common-understanding.md` for the full list
- Stop and report `BLOCKED` for unapproved decisions, files outside your row, or spec ambiguities with two reasonable interpretations

## Final Response

Write to `<results_folder>/<agent_id>/report.md`:

```markdown
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
CHANGED_OR_CHECKED_FILES:

- `path` — summary
  VALIDATION:
- command/evidence: result
  RISKS_OR_QUESTIONS:
- item or none
```

## End-of-Task Notification

When the task is done, run:

```bash
notify-send --app-name "Pi" "Agent <agent_id>: <STATUS>" "<short message>"
```

This fires the user's desktop alert. **Always include it.** If the script is run unattended, this is how the user knows an agent finished.

```

### Naming Conventions

| Type | Pattern | Example | Timeout |
|---|---|---|---|
| Developer | `agent-<NN>.md` | `agent-00.md`, `agent-15.md` | 15m |
| Split (one task split into sub-files) | `agent-<NNa>.md` | `agent-27a.md`, `agent-27b.md` | 15m |
| Reviewer/Fixer | `agent-r<NN>.md` | `agent-r15.md`, `agent-r27.md` | 8m (auto-detected) |

NN = 2-digit, zero-padded (00, 01, ..., 38). The `r` prefix triggers the shorter timeout.

### Sizing Rules

- **Each task must be doable in <5 minutes by a focused agent.** A fast agent on a small task. Not a 30-minute marathon.
- If a task would take longer, split it. Example: a 400-line form component → 7 small section components (27a-27g) + 1 shell.
- **Reviewer/fixer tasks must be doable in 5-8 minutes** (the hard cap). Reviewing + small fix is fine; a full rewrite is not.
- Place reviewer/fixer tasks **after** the developer they review in the `PIPELINE` array. The scheduler runs them in DAG order, not array order, but the array should still read logically.

### When to Add a Reviewer

Add a `r<NN>.md` task at a key risk point. Typical candidates:

- After the core CRUD is done (backend logic correctness)
- After the Tauri/IPC bridge is done (interface correctness)
- After a complex form is assembled (UI correctness)

Don't add reviewers everywhere — they add 5-8 min each. 2-3 strategic reviewers is the sweet spot.

---

## Step 6: Place Tasks in the Right Order

Tasks must satisfy the DAG. The order in `PIPELINE` does NOT matter for execution (the scheduler computes waves), but the array should still read logically:

1. **Setup agents first** (00-03 typical): Cargo.toml, lib.rs skeleton, type definitions
2. **Pure modules next** (04-09): errors, defaults, paths, validations, inline tests for those
3. **CRUD agents** (10-15): create, read, update, delete, integration test
4. **Tauri interface** (17-19): adapter, command registration, verification
5. **Frontend foundation** (20-22): types, service, store
6. **Components** (23-27): individual components, form assembly
7. **Routes** (28-32): layout, list, create/edit pages, header update
8. **E2E** (33-37): per-area specs
9. **Final verification** (38): smoke test

Reviewer/fixer tasks (`r<NN>`) go immediately after the developer they review in the array, but the DAG is what controls execution.

---

## Step 7: Hand Off to the User

After creating all the files, tell the user:

```

Files created at .agents/plans/<branch>/<phase>-execution/:

- <phase>.md
- pipeline.conf
- common-understanding.md
- agent-<NN>.md (×<count> tasks)

To run:
bash scripts/delegate_agents.sh .agents/plans/<branch>/<phase>-execution

If the script times out at 60 min, re-run the same command — it resumes
from the last completed agent.

To force a re-run of a specific agent:
rm .agents/plans/<branch>/<phase>-execution/results/<agent_id>.status

````

---

## Anti-Patterns to Avoid

| Don't | Why |
|---|---|
| Put code samples in the explanation doc (`<phase>.md`) | That doc is for decisions and scope. Code goes in the agent tasks or in a separate spec doc. |
| Make tasks depend on parent chat history | Each child is a fresh session. The shared context is in `common-understanding.md`. |
| Skip `common-understanding.md` | Every agent needs the shared rules, file ownership map, and validation commands. |
| Use a generic role (e.g., "developer") without specifying the outcome | Roles + outcomes are the contract: "developer: implement X". |
| Reference external example files in the agent tasks | Future agents may not have access. Self-contained is mandatory. |
| Forget the `notify-send` line | The user is alerted on agent completion via this. Missing it is silent failure. |
| Make reviewer/fixer tasks too long | 8-min timeout is strict. Review + small fix is fine; a full rewrite is not. |
| Combine setup + execution in the same task | Setup (Cargo.toml, lib.rs skeleton) and execution (impl details) are different cognitive loads. Split them. |
| Add `r<NN>` reviewers after every agent | They add 5-8 min each. 2-3 strategic ones is the sweet spot. |
| Skip the "Required Context" / "Read these skills first" section | The child is a fresh session and has zero context. This is the entry point. |
| Omit the file ownership map from common-understanding.md | Without it, two agents might edit the same file. The map is the single source of truth for "who owns what". |
| Make `pipeline.conf` slot counts too high | Each slot is a concurrent agent. With 2 subscriptions, 2 total slots across all providers is realistic. |
| Use `agent-` IDs that aren't 2-digit or with letter suffix | The script's `[[ "$id" == *r ]]` reviewer detection relies on the `r` prefix. Other formats break the convention. |

---

## Inline Examples

### What one agent task looks like (a tiny one for shape reference)

This is illustrative only — your real tasks will be larger:

```markdown
# Agent — developer: Create Cargo.toml for the providers crate

## Mission

Create `crates/providers/Cargo.toml` with the right deps and add the crate to the workspace.

## Required Context

This task must be complete for a fresh-session child agent. Do not rely on parent chat history.

- `crates/sessions/Cargo.toml` — closest pattern to mirror
- `crates/persistence/Cargo.toml` — for the persistence dep version

Read these skills first:
- `pi-delegation-contract` — the delegation contract format
- `writing-clearly-and-concisely` — clear, active-voice prose
- `writing-plans` — bite-sized task discipline

## Scope and Ownership

You may inspect:
- `Cargo.toml` (root)
- `crates/sessions/Cargo.toml`

You may edit only:
- `Cargo.toml` (root)
- `crates/providers/Cargo.toml` (new)

Do not:
- Change other crate manifests
- Add features the provider doesn't need
- Commit, stage, or push

## Task

Create the manifest and register the workspace member. See template structure in this skill.

## Acceptance Criteria

- `crates/providers/Cargo.toml` exists with deps: `persistence`, `serde`, `serde_json`, `chrono`, `thiserror`, `tracing`
- Root `Cargo.toml` includes `crates/providers` in `members`
- `cargo check -p providers` does not error (warning about missing lib is OK)

## Validation

```bash
cargo check -p providers 2>&1 | head -20
````

## Stop Rules

- See `common-understanding.md` for the full list
- Stop and report `BLOCKED` for unapproved decisions or files outside your row

## Final Response

Write to `<results_folder>/<agent_id>/report.md` using the standard format.

## End-of-Task Notification

```bash
notify-send --app-name "Pi" "Agent <id>: <STATUS>" "<short message>"
```

````

### What `pipeline.conf` looks like for a 3-wave setup

```bash
provider_minimax() { pi --provider minimax --model minimax-m3 --thinking "${THINKING_LEVEL:-medium}" -p "@$1" -p "@$2" -p "$3"; }
provider_mistral() { vibe -p "$3"; }
provider_gpt()     { pi --provider openai-codex --model gpt-5.5 --thinking "${THINKING_LEVEL:-medium}" -p "@$1" -p "@$2" -p "$3"; }

SLOTS=(
  [minimax]=1
  [mistral]=1
  [gpt]=1
)

PIPELINE=(
  "00:minimax:"
  "01:mistral:"
  "02:minimax:"
  "03:minimax:"
  "04:mistral:"
  "r05:gpt:00 01 02 03 04"
  "06:minimax:r05"
  "07:minimax:06"
  "08:minimax:07"
  "10:mistral:07"
  "11:mistral:07"
  "13:mistral:07"
  "r-batch-10-13:gpt:10 11 13"
  "r-batch-6-9:gpt:06 07 08"
  "r-final:gpt:r05 r-batch-10-13 r-batch-6-9"
)
````
