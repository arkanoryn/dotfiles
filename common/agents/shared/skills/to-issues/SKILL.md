---
name: to-issues
description: Break a PRD into a parallel-first execution folder (seams → micro-tasks → per-seam Karen gate → serialized commit) runnable by scripts/delegate_agents.sh.
disable-model-invocation: true
argument-hint: "[prd-path] [minimax=4 vibe=3 gpt=1 karen=minimax fix=gpt commit=claude resolver=gpt]"
---

# To Issues

Break a PRD into an execution folder of micro-tasks that `scripts/delegate_agents.sh` runs as a DAG. **Parallel-first**: maximum safe concurrency — many small cheap agents with small contexts beat few big agents with growing contexts.

## The contract: you do the leg work

The runtime agents do no thinking — they follow instructions. YOU, running this skill, do ALL the hard work now: read the code, resolve every ambiguity, make every decision, spell out every step. **A task file is correct only if executing it requires zero decisions.** If writing a task forces you to leave a choice open, stop and resolve it (against the PRD/ADRs or with the user) before writing the file. Never delegate a decision downward.

## Arguments

The user may pass a provider budget. Grammar: `name=N` declares a coding provider pool with N parallel slots; role assignments name providers for the special tasks:

```
/to-issues .agents/plans/26-avatars/PRD.md minimax=4 vibe=3 gpt=1 karen=minimax fix=gpt commit=claude resolver=gpt
```

- Every `name=N` pool is available for implementation tasks; spread independent tasks across pools to reduce shared blind spots (e.g. backend on minimax, frontend on vibe).
- `karen=` — provider for all `karen-*` reviews (1 slot, thinking `high`). Prefer a different model than the main implementer: different model, different blind spots.
- `fix=` — provider for all `fix-*` tasks (1 slot, thinking `high`). Defaults to the largest coding pool if omitted.
- `commit=` — provider for all `commit-*` tasks. Wrapped as `provider_committer` with **exactly 1 slot** (the runner preflight enforces this) so commits are serialized.
- `resolver=` — provider that repairs failed agents at runtime (`RESOLVER_PROVIDER`, thinking `high` forced by the runner).
- No arguments at all → ask the user for their full budget including `karen`/`fix`/`commit`/`resolver`; do not invent one.

Record the parsed budget at the top of `pipeline.conf` as a comment, and honor it exactly in `SLOTS`.

## Structure: seams, micro-tasks, gates

From the PRD's seams, build this shape:

1. **Seams** = the PRD's vertical slices (tracer bullets). Each seam delivers a narrow but COMPLETE path through every layer, demoable or verifiable on its own. Any prefactoring is its own first seam ("make the change easy, then make the easy change"). Slicing stays vertical — never reorganize into horizontal layers.
2. **Seams form a DAG, not a chain.** A seam depends on another only when it genuinely builds on its output. Independent seams run concurrently — which requires their tasks to have disjoint file ownership. If two seams must touch the same file, add a dependency between them.
3. **Inside a seam, split into micro-tasks** `1a`, `1b`, `1c`… with strictly disjoint file ownership. Small targeted tasks fail less than large ones. Hard limits per task — if ANY is exceeded, split further:
   - one observable behavior (the mission fits one sentence with no "and");
   - ≤ 3 files edited;
   - ≤ 5 acceptance criteria;
   - ≤ 15 minutes for a focused thinking-off agent.
   Tasks within a seam may depend on each other (`1b` after `1a`) when ownership can't be made disjoint.
4. **Every seam ends in a gate:** `karen-<seam>` (reviews the seam, depends on all its tasks) → `fix-<seam>` (depends on `karen-<seam>`; runs even when Karen reports BLOCKED — the runner unblocks the paired fix) → `commit-<seam>` (formats and commits the seam's files). Downstream seams depend on `commit-<seam>`, never on the raw tasks.
5. **The pipeline ends with a whole-PRD gate:** `karen-final` (depends on every terminal `commit-<seam>`) → `fix-final` → `commit-final`.

ID conventions (the runner keys behavior off these):

| Kind           | ID pattern                | Example                 | Timeout   |
| -------------- | ------------------------- | ----------------------- | --------- |
| Implementation | `<seam><letter>[-slug]`   | `1a`, `2b-replay-strip` | developer |
| Seam review    | `karen-<seam>`            | `karen-1`               | reviewer  |
| Seam fix       | `fix-<seam>`              | `fix-1`                 | developer |
| Seam commit    | `commit-<seam>`           | `commit-1`              | committer |
| Final gate     | `karen-final`, `fix-final`, `commit-final` |        | as above  |

The runner pairs `fix-X` with `karen-X` automatically (a BLOCKED review unblocks only its paired fix). Every pipeline id needs a matching `agent-<id>.md`.

## Why parallel commits are safe

Two seams running concurrently would produce dirty commits if committers grabbed whatever is in the worktree. Two mechanisms prevent that:

1. **Ownership-scoped staging** — a committer stages ONLY its seam's owned files by explicit path (the ownership map guarantees disjointness). Never `git add -A` / `git add .`.
2. **Serialized committers** — all `commit-*` tasks share one 1-slot pool, so two committers never touch the git index at the same time. The runner preflight rejects a multi-slot commit provider.

`scripts/format.sh`, which may rewrite files owned by a still-running seam, therefore runs INSIDE the commit task (scoped to the seam's files when it accepts paths), never as a free-floating task.

## Runtime resolver

The runner repairs itself when an agent breaks. If an agent ends `failed`/`timed_out` (not a Karen-reported BLOCKED — that's the fix task's job), the runner spawns a resolver on the `resolver=` provider with the agent's log, results, and task file, instructed to repair the minimum so the agent can re-run — then it resets the agent to `pending` and reschedules it automatically. A resolver that fails or times out is replaced by a fresh one with the same instruction. Caps: `RESOLVER_MAX` spawns per script run (default 3), `RESOLVER_TIMEOUT_SEC` each (default 600). This exists so a broken run does not need a human to paste logs into a fresh session; the caps keep it from looping forever.

## What you produce

A folder `<feature-folder>/executions/` beside the PRD:

| File                      | Purpose                                                       |
| ------------------------- | ------------------------------------------------------------- |
| `pipeline.conf`           | Provider functions, slots, thinking levels, resolver, the DAG |
| `common-understanding.md` | Shared contract every agent reads first                       |
| `agent-<id>.md`           | One micro-task per pipeline id (incl. karen/fix/commit)       |
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

If the runner already exists, never overwrite it silently — check it supports DAG mode, per-provider slots, the STATUS report gates, `--validate`, the `fix-X`/`karen-X` pairing, the resolver (`RESOLVER_PROVIDER`), and the `commit-*` 1-slot preflight; report drift to the user instead of patching it unasked.

## Task-file checklist (zero-thinking execution)

Implementation, fix, and commit tasks run with `thinking: off`. Before writing any task file, verify it passes EVERY check below. A failed check means the breakdown is wrong — fix the breakdown, not the wording.

1. **Fresh-session complete.** The file names every path to read and every path to edit, exactly. No reference to chat history, "as discussed", "see above", or the content of sibling tasks.
2. **Zero decisions.** No architecture, API, security, data-model, or scope choice is left to the agent. If the PRD/ADRs don't settle it, settle it with the user first.
3. **Concrete targets.** The exact function/module to extend or mirror is named; binding PRD language is quoted verbatim; edge cases are an explicit bullet list, never "handle edge cases".
4. **Mechanical acceptance.** Every acceptance criterion is provable by a command or test named in the same file — an agent can check its own work without judgment.
5. **Thinking stays off.** Raise `THINKING_OVERRIDES` only: `high` for `karen-*`/`fix-*`, `medium` for `commit-*` and genuinely tricky cross-cutting tasks. Never raise it to compensate for a vague task file — the task text carries the intelligence.

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

**`karen-<seam>`** files are short: mission ("review seam <N> as completed: tasks <ids>"), the seam's task ids and owned files, and: *"Use the `karen-review` skill in mode `execution`, scoped to this seam only. Read-only — do not edit source files. Write the review to `<executions>/karen-<seam>-review.md` and `results/karen-<seam>/report.md`. If any unfixed MEDIUM+ issue remains, report STATUS: BLOCKED so `fix-<seam>` must address it."*

**`fix-<seam>`** files: mission ("resolve every MEDIUM+ issue in `karen-<seam>-review.md`"), ownership = union of the seam's files, validation = the seam's commands, and: *"If the review found no MEDIUM+ issues, verify that claim briefly and report DONE."*

**`commit-<seam>`** files — the ONLY tasks allowed to run git write commands. Template:

````markdown
# Agent commit-<seam> — format and commit seam <N>'s reviewed work

## Mission

Format seam <N>'s files and commit them. Nothing else.

## Scope and ownership

Seam <N>'s owned files (union of the ownership map rows for tasks <ids>):
<explicit path list>

## Task

1. If `scripts/format.sh` exists, run it on the files above (pass the paths if it accepts arguments; otherwise run it as-is).
2. If `git diff --cached` is non-empty BEFORE you stage anything, report `BLOCKED` — someone else's work is staged.
3. Stage ONLY the files listed above, by explicit path. Never `git add -A`, `git add .`, or `git add -u`.
4. Commit using the `commit-work` skill if available; otherwise write a Conventional Commits message yourself (`<type>(<scope>): <summary>` + body explaining why). Split into multiple commits only if the skill says so.
5. Never push. Never amend or rebase existing commits.

## Acceptance criteria

- [ ] `git log` shows the new commit(s) containing exactly the owned files
- [ ] `git diff --cached` is empty afterwards

## Report

Write `results/commit-<seam>/report.md` per common-understanding.md.
````

**`karen-final` / `fix-final` / `commit-final`**: same patterns, scoped to the whole PRD; `karen-final` verifies the seam reviews' conclusions instead of trusting them; `commit-final` commits only what `fix-final` changed.

## Step 4 — pipeline.conf

Start from [templates/pipeline.conf.example](templates/pipeline.conf.example) (resolve relative to this SKILL.md) and adapt: provider functions to the budget's pools, `provider_committer` to the `commit=` assignment, `RESOLVER_PROVIDER` to the `resolver=` assignment, `SLOTS` to the budget's counts (committer stays 1), `PI_SESSION_PREFIX` to `NN-feature-title`, `THINKING_OVERRIDES` for every `karen-*`/`fix-*` (high) and `commit-*` (medium), and the `PIPELINE` DAG to your seams. Keep it Bash-3 compatible (stock macOS): plain arrays, no associative arrays.

The DAG shape, condensed:

```bash
PIPELINE=(
  # "<id>:<provider>:<space-separated deps>"
  "1a:minimax:"  "1b:vibe:"  "1c:minimax:1a"          # seam 1: parallel micro-tasks
  "karen-1:karen:1a 1b 1c"  "fix-1:gpt:karen-1"  "commit-1:committer:fix-1"
  "2a:minimax:"  "2b:vibe:"                            # seam 2: concurrent with seam 1
  "karen-2:karen:2a 2b"     "fix-2:gpt:karen-2"  "commit-2:committer:fix-2"
  "3a:minimax:commit-1 commit-2"                       # seam 3: builds on both gates
  "karen-3:karen:3a"        "fix-3:gpt:karen-3"  "commit-3:committer:fix-3"
  "karen-final:karen:commit-3" "fix-final:gpt:karen-final" "commit-final:committer:fix-final"
)
```

Set generous timeouts for heavy builds (Rust workspace + E2E): `AGENT_TIMEOUT_SEC=1800`, `REVIEWER_TIMEOUT_SEC=900`, `TOTAL_TIMEOUT_SEC` sized to the pipeline's critical path (resolver time included), all overridable from the environment.

## Step 5 — Validate before handoff

```bash
bash -n <executions>/pipeline.conf
bash scripts/delegate_agents.sh --validate <executions>   # preflight only, runs nothing
```

Also verify by hand:

- Every `PIPELINE` id has `agent-<id>.md`, and every `agent-*.md` is in the pipeline.
- Every provider used has a `provider_<name>()` and a `SLOTS` entry; Pi providers pass `--name "${PI_SESSION_NAME}"`; `committer=1`; `RESOLVER_PROVIDER` names a defined provider.
- Deps reference existing ids; no cycles; every seam ends `karen-<seam>` → `fix-<seam>` → `commit-<seam>`; the pipeline ends `karen-final` → `fix-final` → `commit-final`.
- Concurrent tasks (same wave or independent seams) have disjoint file ownership per the map; commit tasks stage only their seam's paths.
- Every task file passes the task-file checklist above.

Then hand off:

```
To run:      bash scripts/delegate_agents.sh <executions-folder>
Recommended: have Karen review the plan first (karen-review skill, mode `plan`).
Resume:      re-run the same command; completed agents are preserved.
Force re-run of one agent: rm <executions>/results/<id>.status
Resolver:    automatic; tune RESOLVER_MAX / RESOLVER_TIMEOUT_SEC in the environment.
```

## Anti-patterns

| Don't | Why |
| ----- | --- |
| Serial chain of fat seam-tasks (one agent per seam) | Context grows, cost explodes, one slow agent blocks everything |
| A task with two behaviors "because they're related" | Small targeted tasks fail less; split it |
| Two concurrent tasks touching one file | Race; add a dep or merge the tasks |
| `git add -A` / commit tasks on a multi-slot pool | Dirty commits from concurrent seams; ownership-scoped staging + 1 slot is the whole safety model |
| format.sh as its own parallel task | It rewrites files other seams still own; it belongs inside the serialized commit task |
| Karen and implementer on the same model when the budget allows otherwise | Same blind spots |
| Skipping the seam gate to save time | Final review then drowns; per-seam fixes are cheap because context is small |
| Task files that assume chat history | Fresh sessions know nothing |
| Decisions smuggled into task files | Violates the leg-work contract; resolve in PRD/ADR first |
| `thinking` raised everywhere "to be safe" | Cost without benefit; the task text carries the intelligence |
| Counting on the resolver as a safety net for vague tasks | The resolver repairs broken runs, not broken breakdowns |
