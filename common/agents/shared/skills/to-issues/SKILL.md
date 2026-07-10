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
- `commit=` — provider for `commit-final` ONLY. Per-seam commits run natively inside the runner (reserved provider `git`, no agent, no LLM) — see "Seam commits are native". Wrapped as `provider_committer` with **exactly 1 slot** (preflight-enforced).
- `resolver=` — provider that repairs failed agents at runtime (`RESOLVER_PROVIDER`, thinking `high` forced by the runner). Transient provider aborts never reach the resolver — the runner retries those itself (see "Runtime resilience").
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
4. **Every seam ends in a gate:** `karen-<seam>` (reviews the seam, depends on all its tasks) → `fix-<seam>` (depends on `karen-<seam>`; runs even when Karen reports BLOCKED — the runner unblocks the paired fix) → `commit-<seam>` (a native runner commit of the seam's files — no agent). Downstream seams depend on `commit-<seam>`, never on the raw tasks.
5. **The pipeline ends with a whole-PRD gate:** `karen-final` (depends on every terminal `commit-<seam>`) → `fix-final` → `commit-final`.

ID conventions (the runner keys behavior off these):

| Kind           | ID pattern                | Example                 | Timeout   |
| -------------- | ------------------------- | ----------------------- | --------- |
| Implementation | `<seam><letter>[-slug]`   | `1a`, `2b-replay-strip` | developer |
| Seam review    | `karen-<seam>`            | `karen-1`               | reviewer  |
| Seam fix       | `fix-<seam>`              | `fix-1`                 | developer |
| Seam commit    | `commit-<seam>` (native)  | `commit-1`              | committer |
| Final gate     | `karen-final`, `fix-final`, `commit-final` |        | as above  |

The runner pairs `fix-X` with `karen-X` automatically (a BLOCKED review unblocks only its paired fix). Every pipeline id needs a matching `agent-<id>.md` — except native commits, which need `agent-<id>.commit` instead.

## Seam commits are native

Seam commits are **checkpoints, not deliverables** — they don't need to compile, pass hooks, or carry a polished message. Only the final gate produces real history. So per-seam `commit-<seam>` tasks use the runner's reserved provider `git`: no agent, no LLM slot, no report parsing, no hook failures. The runner reads `agent-commit-<seam>.commit` (first non-comment line = commit message, remaining lines = explicit paths), stages ONLY those paths, and runs `git commit --no-verify` scoped to them.

Why this is safe under concurrency:

1. **Ownership-scoped staging** — the manifest lists the seam's owned paths explicitly (the ownership map guarantees disjointness); pathspec-scoped commit means other seams' staged/dirty files are untouched. Never a `git add -A` anywhere.
2. **Serialization** — the `git` provider defaults to 1 slot, so two native commits never interleave index operations.

You write the manifest at breakdown time (message: `wip(seam <N>): <seam title>`; paths: the union of the seam's ownership rows plus test files those tasks create). `commit-final` stays an agent: it runs `scripts/format.sh` (formatting is deferred to the end — it would rewrite files still owned by running seams), stages what `fix-final` changed, and uses the `commit-work` skill to craft the real message. If the wip history should be squashed/reworded, that is a human decision after the run — say so in the handoff.

## Runtime resilience

Two mechanisms, in escalation order:

1. **Abort retry (cheap, automatic).** A provider-side abort (log matches `ABORT_PATTERN`, default `Unhandled stop reason: abort`, and no `report.md` was written) is transient overload, not broken state. The runner re-queues the agent after `ABORT_RETRY_DELAY_SEC` (default 300), up to `ABORT_RETRY_MAX` (default 2) times per agent, without consuming resolver budget.
2. **Resolver (expensive, for real breakage).** If an agent ends `failed`/`timed_out` for any other reason — or exhausts its abort retries — the runner spawns a resolver on the `resolver=` provider with the agent's log, results, and task file, instructed to repair the minimum (revert half-applied edits, unstick tooling) so the agent can re-run, then reschedules it. A resolver that fails or times out is replaced by a fresh one. Caps: `RESOLVER_MAX` spawns per script run (default 3), `RESOLVER_TIMEOUT_SEC` each (default 600).

This split matters: a run that spends its 3 resolver slots writing "nothing to repair, just re-run it" for transient aborts has no budget left when an agent leaves genuinely broken state.

## What you produce

A folder `<feature-folder>/executions/` beside the PRD:

| File                       | Purpose                                                       |
| -------------------------- | ------------------------------------------------------------- |
| `pipeline.conf`            | Provider functions, slots, thinking levels, resolver, the DAG |
| `common-understanding.md`  | Shared contract every agent reads first                       |
| `agent-<id>.md`            | One micro-task per pipeline id (karen/fix/commit-final incl.) |
| `agent-commit-<seam>.commit` | Native commit manifest: message line + explicit paths       |
| `results/`                 | Created at runtime; do not pre-create                         |

**Runner bootstrap:** this skill bundles the runner and a reference pipeline. Resolve template paths relative to this `SKILL.md`:

```bash
mkdir -p scripts
if [ ! -f scripts/delegate_agents.sh ]; then
  cp <skill-dir>/templates/delegate_agents.sh scripts/delegate_agents.sh
  chmod +x scripts/delegate_agents.sh
fi
bash -n scripts/delegate_agents.sh
```

If the runner already exists, never overwrite it silently — check it supports DAG mode, per-provider slots, the STATUS report gates, `--validate`, the `fix-X`/`karen-X` pairing, the resolver (`RESOLVER_PROVIDER`), abort retry (`ABORT_PATTERN`), native `git`-provider commits (`agent-<id>.commit`), and the `commit-*` 1-slot preflight; report drift to the user instead of patching it unasked.

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

Scope validation to YOUR seam (specific crates/packages/test modules). Other seams run concurrently and may be mid-edit: a failure in a file outside your ownership is NOT your failure — report it under RISKS_OR_QUESTIONS ("out-of-seam: <file>: <error>") and judge your own work only by your seam's gates.

## Report format

Every agent ends by writing `results/<agent_id>/report.md`. The STATUS line contains the keyword and NOTHING else — no dashes, notes, or parentheses after it (the runner parses it mechanically):

```markdown
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
CHANGED_OR_CHECKED_FILES:
- `path` — summary
VALIDATION:
- command/evidence: result
RISKS_OR_QUESTIONS:
- item or none
```

Fix agents (`fix-*`) additionally append an attribution section (consumed by the post-run retro — be specific and honest):

```markdown
FIX_ATTRIBUTION:
- issue: <one line — what was broken>
  from: <task id that introduced it, e.g. 4b>
  cause: vague-task | wrong-task-spec | model-error | missing-context | cross-seam-interference | tooling
  prevention: <one line — what change to the task file / common-understanding would have prevented it>
```

## Stop rules

Report `BLOCKED` (do not guess) for: an unapproved product/architecture/API/security/data-model/scope decision; a file outside your ownership row (fix agents: see your task file — you have a minimal-repair exception); a spec ambiguity with two reasonable interpretations; a test failure you cannot resolve within your scope. For minor ambiguities (a field name, a default), pick the reasonable option and note it under RISKS_OR_QUESTIONS.

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

**`karen-<seam>`** files are short: mission ("review seam <N> as completed: tasks <ids>"), the seam's task ids and owned files, and: *"Use the `karen-review` skill in mode `execution`, scoped to this seam only. Read-only — do not edit source files. Failures rooted in files outside this seam's ownership are recorded as observations, not blockers. Write the review to `<executions>/karen-<seam>-review.md` and `results/karen-<seam>/report.md`. If any unfixed MEDIUM+ issue remains INSIDE the seam, report STATUS: BLOCKED so `fix-<seam>` must address it."*

**`fix-<seam>`** files: mission ("resolve every MEDIUM+ issue in `karen-<seam>-review.md`"), ownership = union of the seam's files, validation = the seam's commands, and both of:

- *"If the review found no MEDIUM+ issues, verify that claim briefly and report DONE."*
- The minimal-repair exception: *"Your primary scope is the seam's files. If a seam validation gate cannot pass without a change outside them (a broken test helper, a missing dependency declaration, a one-line compile fix), make the MINIMAL out-of-scope edit rather than reporting BLOCKED — and list every out-of-scope file under CHANGED_OR_CHECKED_FILES with the reason. Do not refactor, restructure, or fix unrelated issues outside the seam."*

(Rationale: by the time `fix-<seam>` runs, its seam's implementers are finished, so the file-race the ownership map exists for is gone; a fixer that reports BLOCKED over a one-line out-of-scope repair forces the human intervention this pipeline exists to remove.)

Fix task files must also require the `FIX_ATTRIBUTION` report section from common-understanding.md.

**`commit-<seam>`** — no task file. Write the manifest `agent-commit-<seam>.commit` instead:

```
# seam <N> checkpoint — consumed natively by delegate_agents.sh
wip(seam <N>): <seam title>
crates/<...>/src/<file1>.rs
crates/<...>/src/<file2>.rs
crates/<...>/tests/<test file>.rs
```

First non-comment line is the commit message; every following line is a path (union of the seam's ownership rows; include test files the tasks create). Missing paths are skipped, an empty diff is a no-op DONE — both are fine.

**`karen-final` / `fix-final` / `commit-final`**: same patterns, scoped to the whole PRD; `karen-final` verifies the seam reviews' conclusions instead of trusting them; workspace-wide validation IS in scope here. `commit-final` is an agent (the `committer` provider): it runs `scripts/format.sh` if present, stages what `fix-final` and formatting changed, and commits via the `commit-work` skill with a real Conventional Commits message. It never pushes, amends, or rebases.

## Step 4 — pipeline.conf

Start from [templates/pipeline.conf.example](templates/pipeline.conf.example) (resolve relative to this SKILL.md) and adapt: provider functions to the budget's pools, `provider_committer` to the `commit=` assignment (used by `commit-final` only), `RESOLVER_PROVIDER` to the `resolver=` assignment, `SLOTS` to the budget's counts (committer stays 1; `git` needs no function and no SLOTS entry — it defaults to 1), `PI_SESSION_PREFIX` to `NN-feature-title`, `THINKING_OVERRIDES` for every `karen-*`/`fix-*` (high) and `commit-final` (medium), and the `PIPELINE` DAG to your seams. Keep it Bash-3 compatible (stock macOS): plain arrays, no associative arrays.

The DAG shape, condensed:

```bash
PIPELINE=(
  # "<id>:<provider>:<space-separated deps>"
  "1a:minimax:"  "1b:vibe:"  "1c:minimax:1a"          # seam 1: parallel micro-tasks
  "karen-1:karen:1a 1b 1c"  "fix-1:gpt:karen-1"  "commit-1:git:fix-1"
  "2a:minimax:"  "2b:vibe:"                            # seam 2: concurrent with seam 1
  "karen-2:karen:2a 2b"     "fix-2:gpt:karen-2"  "commit-2:git:fix-2"
  "3a:minimax:commit-1 commit-2"                       # seam 3: builds on both gates
  "karen-3:karen:3a"        "fix-3:gpt:karen-3"  "commit-3:git:fix-3"
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

- Every `PIPELINE` id has `agent-<id>.md` (or `agent-<id>.commit` for `git`-provider commits), and every `agent-*.md` / `agent-*.commit` is in the pipeline.
- Every provider used has a `provider_<name>()` and a `SLOTS` entry (`git` excepted — it's built in); Pi providers pass `--name "${PI_SESSION_NAME}"`; `committer=1`; `RESOLVER_PROVIDER` names a defined provider.
- Deps reference existing ids; no cycles; every seam ends `karen-<seam>` → `fix-<seam>` → `commit-<seam>`; the pipeline ends `karen-final` → `fix-final` → `commit-final`.
- Concurrent tasks (same wave or independent seams) have disjoint file ownership per the map; each commit manifest lists exactly its seam's paths.
- Each seam's validation commands are scoped to that seam (specific crates/packages/test modules), not the whole workspace — workspace-wide gates belong to `karen-final` only.
- Every task file passes the task-file checklist above; every `fix-*` file carries the minimal-repair exception and the `FIX_ATTRIBUTION` requirement.

Then hand off:

```
To run:      bash scripts/delegate_agents.sh <executions-folder>
Recommended: have Karen review the plan first (karen-review skill, mode `plan`).
Resume:      re-run the same command; completed agents are preserved.
Force re-run of one agent: rm <executions>/results/<id>.status
Abort retry: automatic; tune ABORT_RETRY_MAX / ABORT_RETRY_DELAY_SEC / ABORT_PATTERN in the environment.
Resolver:    automatic; tune RESOLVER_MAX / RESOLVER_TIMEOUT_SEC in the environment.
After the run: /pipeline-retro <executions-folder> to score providers and harvest improvements.
```

## Anti-patterns

| Don't | Why |
| ----- | --- |
| Serial chain of fat seam-tasks (one agent per seam) | Context grows, cost explodes, one slow agent blocks everything |
| A task with two behaviors "because they're related" | Small targeted tasks fail less; split it |
| Two concurrent tasks touching one file | Race; add a dep or merge the tasks |
| An LLM agent for seam commits | Checkpoints need no judgment; a deterministic runner commit can't be blocked by hooks, sandboxes, or report-format drift |
| `git add -A` anywhere / commit provider on a multi-slot pool | Dirty commits from concurrent seams; manifest-scoped staging + 1 slot is the whole safety model |
| format.sh as its own parallel task or per-seam | It rewrites files other seams still own; it runs once, inside `commit-final` |
| Workspace-wide validation gates on seam tasks | Concurrent seams' in-flight breakage bleeds in; Karen blocks on noise and fixers chase other seams' bugs |
| Fix tasks hard-blocked by the ownership map | Their seam is already done; a one-line out-of-scope repair beats a BLOCKED report and a human intervention |
| Karen and implementer on the same model when the budget allows otherwise | Same blind spots |
| Skipping the seam gate to save time | Final review then drowns; per-seam fixes are cheap because context is small |
| Task files that assume chat history | Fresh sessions know nothing |
| Decisions smuggled into task files | Violates the leg-work contract; resolve in PRD/ADR first |
| `thinking` raised everywhere "to be safe" | Cost without benefit; the task text carries the intelligence |
| Counting on the resolver as a safety net for vague tasks | The resolver repairs broken runs, not broken breakdowns |
