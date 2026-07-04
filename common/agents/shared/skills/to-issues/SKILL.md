---
name: to-issues
description: Break a PRD into a parallel-first execution folder (seams → parallel tasks → per-seam Karen gate) runnable by scripts/delegate_agents.sh.
disable-model-invocation: true
argument-hint: "[prd-path] [minimax=4 vibe=3 gpt=1 karen=minimax fix=gpt]"
---

# To Issues

Break a PRD into an execution folder of micro-tasks that `scripts/delegate_agents.sh` runs as a DAG. **Parallel-first**: the goal is maximum safe concurrency, so many small cheap agents finish fast with small contexts, instead of few big agents with growing contexts.

## Arguments

The user may pass a provider budget. Grammar: `name=N` declares a coding provider pool with N parallel slots; `karen=<provider>` and `fix=<provider>` assign the review and fix roles.

```
/to-issues .agents/plans/26-avatars/PRD.md minimax=4 vibe=3 gpt=1 karen=minimax fix=gpt
```

- Every `name=N` pool is available for implementation tasks; spread independent tasks across pools to reduce shared blind spots (e.g. backend on minimax, frontend on vibe).
- `karen=` names the provider for all `karen-*` review tasks (1 slot, thinking `high`). Prefer a different model than the main implementer — different model, different blind spots.
- `fix=` names the provider for all `fix-*` tasks (1 slot, thinking `high`). Defaults to the largest coding pool if omitted.
- No arguments at all → ask the user for their budget; do not invent one.

Record the parsed budget at the top of `pipeline.conf` as a comment, and honor it exactly in `SLOTS`.

## Structure: seams, tasks, gates

From the PRD's seams, build this shape:

1. **Seams** = the PRD's vertical slices (tracer bullets). Each seam delivers a narrow but COMPLETE path through every layer, demoable or verifiable on its own. Any prefactoring is its own first seam ("make the change easy, then make the easy change").
2. **Seams form a DAG, not a chain.** A seam depends on another seam only when it genuinely builds on its output. Independent seams run concurrently — which requires their tasks to have disjoint file ownership. If two seams must touch the same file, add a dependency between them.
3. **Inside a seam, split into parallel tasks** `1a`, `1b`, `1c`… with strictly disjoint file ownership. Each task ≤ 15 minutes for a focused low-thinking agent — if bigger, split further. Tasks within a seam may also depend on each other (`1b` after `1a`) when ownership can't be made disjoint.
4. **Every seam ends in a gate:** `karen-<seam>` (reviews the seam, depends on all its tasks) then `fix-<seam>` (depends on `karen-<seam>`; runs even when Karen reports BLOCKED — the runner unblocks the paired fix). Downstream seams depend on `fix-<seam>`, not on the raw tasks.
5. **The pipeline ends with a whole-PRD gate:** `karen-final` (depends on every terminal `fix-<seam>`) then `fix-final`. Do not add a commit task unless the user asks for one.

ID conventions (the runner keys behavior off these):

| Kind        | ID pattern                  | Example           | Timeout   |
| ----------- | --------------------------- | ----------------- | --------- |
| Implementation | `<seam><letter>[-slug]`  | `1a`, `2b-replay-strip` | developer |
| Seam review | `karen-<seam>`              | `karen-1`         | reviewer  |
| Seam fix    | `fix-<seam>`                | `fix-1`           | developer |
| Final gate  | `karen-final`, `fix-final`  |                   | reviewer / developer |

The runner pairs `fix-X` with `karen-X` automatically (a BLOCKED review unblocks only its paired fix). Every pipeline id needs a matching `agent-<id>.md`.

## What you produce

A folder `<feature-folder>/executions/` beside the PRD:

| File                      | Purpose                                                       |
| ------------------------- | ------------------------------------------------------------- |
| `pipeline.conf`           | Provider functions, slots, thinking levels, the DAG           |
| `common-understanding.md` | Shared contract every agent reads first                       |
| `agent-<id>.md`           | One micro-task per pipeline id (including karen-* and fix-*)  |
| `results/`                | Created at runtime; do not pre-create                         |

**Runner bootstrap:** this skill bundles the runner and a reference pipeline. Resolve template paths relative to this `SKILL.md`:

```bash
mkdir -p scripts
if [ ! -f scripts/delegate_agents.sh ]; then
  cp <skill-dir>/templates/delegate_agents.sh scripts/delegate_agents.sh
  chmod +x scripts/delegate_agents.sh
fi
bash -n scripts/delegate_agents.sh
```

If the runner already exists, never overwrite it silently — check it supports DAG mode, per-provider slots, the STATUS report gates, `--validate`, and the `fix-X`/`karen-X` pairing; report drift to the user instead of patching it unasked.

## Writing for less-smart models

Every implementation and fix task will run with `thinking: off` unless overridden. Therefore:

- The task file must contain **everything** needed: exact expected behavior, acceptance criteria, file ownership, validation commands, required reading. No reliance on parent chat history — each agent is a fresh session.
- Prefer concrete over clever: name the function to extend, quote the PRD section that binds, state the edge cases explicitly.
- Decisions belong in the PRD/ADRs, never delegated: if a task would force the agent to make an architecture, API, security, data-model, or scope decision, the breakdown is wrong — resolve it first.
- Raise `THINKING_OVERRIDES` to `high` only for `karen-*` and `fix-*`, and `medium` for genuinely tricky cross-cutting tasks. Default stays `off`.

## Step 1 — Read and quiz

Read the PRD, `CONTEXT.md`, relevant `docs/adr/`, and explore the code. Then present the proposed breakdown as a table: seam → tasks (with one-line missions) → dependencies → provider assignment. Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the seam dependencies correct? Could any be parallelized further?
- Is the provider distribution right?

Iterate until approved. Only then write files.

## Step 2 — common-understanding.md

Adapt this template. Keep it short — it is read by every agent, so every line costs tokens × agents.

````markdown
# Common Understanding — <Feature>

> Read this before your `agent-<id>.md`. You are a fresh session with zero context.

## Mission

<1-2 sentences.>

## Binding documents

- `<path-to-PRD>` — the spec; it wins over this file on conflict
- `CONTEXT.md` — use its vocabulary
- `docs/adr/` — decisions are binding
- `.agents/instructions/*.md` — coding standards, if present

## Hard rules

<Project-wide rules every agent must follow. Keep to the ones that are real.>

## TDD (required for implementation tasks)

Work test-first in vertical slices: write ONE failing test for the next behavior, watch it fail, write minimal code to pass, repeat. Never write all tests up front. Test behavior through public interfaces — a test that breaks when you refactor internals is testing the wrong thing. See the `tdd` skill if available.

## File ownership map

| Agent | Files owned |
| ----- | ----------- |
| 1a    | `<paths>`   |

If your task needs a file not on your row, stop and report `BLOCKED`.

## Validation commands

| Layer | Command |
| ----- | ------- |
| <layer> | `<command>` |

## Report format

Every agent ends by writing `results/<agent_id>/report.md`:

```markdown
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
CHANGED_OR_CHECKED_FILES:
- `path` — summary
VALIDATION:
- command/evidence: result
RISKS_OR_QUESTIONS:
- item or none
```

## Stop rules

Report `BLOCKED` (do not guess) for: an unapproved product/architecture/API/security/data-model/scope decision; a file outside your ownership row; a spec ambiguity with two reasonable interpretations; a test failure you cannot resolve within your scope. For minor ambiguities (a field name, a default), pick the reasonable option and note it under RISKS_OR_QUESTIONS.

## Notification

On completion, if practical:
- macOS: `osascript -e 'display notification "{message}" with title "Pi" subtitle "{STATUS}"'`
- Linux: `notify-send --app-name "Pi" "{STATUS}" "{message}"`
````

## Step 3 — Agent task files

One `agent-<id>.md` per pipeline id. Implementation/fix template:

````markdown
# Agent <id> — <one-line outcome>

## Mission

<One sentence. The observable deliverable.>

## Required reading

- `<PRD path>` — sections <X, Y>
- `<code path>` — <why: the thing you extend / the pattern to mirror>
- `.agents/instructions/<relevant>.md`

## Scope and ownership

You may edit only: <exact paths from the ownership map>.
Do not: edit other files (report `BLOCKED` instead), commit/stage/push, read secrets or `.env`, widen scope.

## Task

<Specific instructions. Quote binding PRD language. Name the exact modules/functions. List edge cases. Follow the TDD loop from common-understanding.md: one failing test → minimal code → repeat.>

## Acceptance criteria

- [ ] <Observable behavior, phrased so a validation command or test proves it>
- [ ] <...>
- [ ] Validation commands for the affected layers pass

## Validation

```bash
<commands>
```

## Report

Write `results/<id>/report.md` per common-understanding.md, then send the notification.
````

`karen-<seam>` task files are short: mission ("review seam <N> as completed: tasks <ids>"), the seam's task ids and owned files, and: *"Use the `karen-review` skill in mode `execution`, scoped to this seam only. Read-only — do not edit source files. Write the review to `<executions>/karen-<seam>-review.md` and `results/karen-<seam>/report.md`. If any unfixed MEDIUM+ issue remains, report STATUS: BLOCKED so `fix-<seam>` must address it."*

`fix-<seam>` task files: mission ("resolve every MEDIUM+ issue in `karen-<seam>-review.md`"), ownership = union of the seam's files, validation = the seam's commands, and: *"If the review found no MEDIUM+ issues, verify that claim briefly and report DONE."*

`karen-final` / `fix-final`: same pattern, scoped to the whole PRD; karen-final verifies the seam reviews' conclusions instead of trusting them.

## Step 4 — pipeline.conf

Start from [templates/pipeline.conf.example](templates/pipeline.conf.example) (resolve relative to this SKILL.md) and adapt: provider functions to the budget's pools, `SLOTS` to the budget's counts, `PI_SESSION_PREFIX` to `NN-feature-title`, `THINKING_OVERRIDES` for every `karen-*`/`fix-*`, and the `PIPELINE` DAG to your seams. Keep it Bash-3 compatible (stock macOS): plain arrays, no associative arrays.

The DAG shape, condensed:

```bash
PIPELINE=(
  # "<id>:<provider>:<space-separated deps>"
  "1a:minimax:"  "1b:vibe:"  "1c:minimax:1a"     # seam 1: parallel tasks
  "karen-1:karen:1a 1b 1c"  "fix-1:gpt:karen-1"  # seam 1 gate
  "2a:minimax:"  "2b:vibe:"                       # seam 2: concurrent with seam 1
  "karen-2:karen:2a 2b"     "fix-2:gpt:karen-2"
  "3a:minimax:fix-1 fix-2"                        # seam 3: builds on both gates
  "karen-3:karen:3a"        "fix-3:gpt:karen-3"
  "karen-final:karen:fix-3" "fix-final:gpt:karen-final"  # whole-PRD gate, always last
)
```

Set generous timeouts for heavy builds (Rust workspace + E2E): `AGENT_TIMEOUT_SEC=1800`, `REVIEWER_TIMEOUT_SEC=900`, `TOTAL_TIMEOUT_SEC` sized to the pipeline's critical path, all overridable from the environment.

## Step 5 — Validate before handoff

```bash
bash -n <executions>/pipeline.conf
bash scripts/delegate_agents.sh --validate <executions>   # preflight only, runs nothing
```

Also verify by hand:

- Every `PIPELINE` id has `agent-<id>.md`, and every `agent-*.md` is in the pipeline.
- Every provider used has a `provider_<name>()` and a `SLOTS` entry; Pi providers pass `--name "${PI_SESSION_NAME}"`.
- Deps reference existing ids; no cycles; every seam ends `karen-<seam>` → `fix-<seam>`; the pipeline ends `karen-final` → `fix-final`.
- Concurrent tasks (same wave or independent seams) have disjoint file ownership per the map.
- No task forces a decision; each is completable with `thinking: off`.

Then hand off:

```
To run:      bash scripts/delegate_agents.sh <executions-folder>
Recommended: have Karen review the plan first (karen-review skill, mode `plan`).
Resume:      re-run the same command; completed agents are preserved.
Force re-run of one agent: rm <executions>/results/<id>.status
```

## Anti-patterns

| Don't | Why |
| ----- | --- |
| Serial chain of fat seam-tasks (one agent per seam) | Context grows, cost explodes, one slow agent blocks everything — the exact failure of Workflow 2 |
| Two concurrent tasks touching one file | Race; add a dep or merge the tasks |
| Karen and implementer on the same model when the budget allows otherwise | Same blind spots |
| Skipping the seam gate to save time | Final review then drowns; per-seam fixes are cheap because context is small |
| Task files that assume chat history | Fresh sessions know nothing |
| Decisions smuggled into task files | Low-thinking agents will guess; resolve in PRD/ADR first |
| `thinking` raised everywhere "to be safe" | Cost without benefit; the task text should carry the intelligence |
