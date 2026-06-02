---
name: pi-delegation-contract
description: Use when delegating work to Pi subagents, drafting child prompts, launching delegate-pi workflows, or turning work into agent-owned tasks
---

# Pi Delegation Contract

## Overview

Delegation succeeds when the parent gives each child a written contract: one role, one outcome, clear boundaries, focused validation, and a final report shape. `pi-subagents` supplies the runtime; this skill supplies the quality gate before launch.

**REQUIRED SUB-SKILL:** Use `writing-clearly-and-concisely` before writing delegation documents, `common-understanding.md`, agent task files, chain tasks, or inline subagent prompts. Child instructions are human-readable prose with operational consequences. Make them concrete, active, and lean.

## When to Use

Use this skill when:

- The user asks to `delegate-pi`, delegate to Pi, use subagents, run reviewers, launch workers, or orchestrate agents.
- A task needs scouts, planners, reviewers, validators, or a worker handoff.
- You are about to write subagent task prompts, plan files, common context, or chain steps.
- The work is complex, risky, multi-step, ambiguity-heavy, or benefits from fresh-context review.

Do not use when one focused parent edit is faster and safer. No committee for a splinter.

## Delegation Gate

Before launching a child, fill this contract. If any required field is missing, either inspect evidence, ask one clarifying question, or do not delegate.

| Field | Requirement |
|---|---|
| Role | `karen`, `planner`, `developer`, `reviewer`, `worker`, `scout`, etc. |
| Goal | One observable outcome. No “help with” fog. |
| Context | Files, diffs, plans, decisions, or docs the child must inspect. |
| Scope | Owned files/areas and explicit non-goals. |
| Ownership | Exact files each child may edit; no two parallel writers may own the same file. |
| Boundaries | Read-only or writer; no commits; no ignored/secret files; no broad refactors. |
| Validation | Exact commands/checks, or the next-best evidence if commands cannot run. |
| Context mode | `fresh` by default, including developers. Use `fork` only for explicit parent-history audits. |
| Output | Required final format: status, changed/checked files, validation, risks, questions. |
| Stop rules | When to escalate instead of guessing. |

## Default Flow

1. Decide whether delegation is justified. Skip for trivial edits.
2. Load `writing-clearly-and-concisely`.
3. Create a delegation directory:

```fish
mkdir -p .agents/plans/<area>/<fix-name>
```

4. Write `.agents/plans/<area>/<fix-name>/common-understanding.md` with the shared goal, context, constraints, file ownership, validation commands, and final reporting format.
5. Write one `.agents/plans/<area>/<fix-name>/agent-{id}.md` per micro-task.
6. Draft every task contract in concrete language.
7. Treat child sessions as fresh by default. `common-understanding.md` plus each `agent-{id}.md` must contain every fact the child needs: user intent, constraints, non-goals, relevant files, accepted decisions, validation, and escalation rules. Do not rely on parent chat history to fill gaps.
8. Parallelize agents only when their owned tasks and files do not overlap. Parallel read-only work is usually safe. Parallel implementation is allowed only with explicit file ownership; use isolated worktrees when overlap risk is non-trivial.
9. Launch through `pi-subagents` with `context: "fresh"` for developers unless a rare task explicitly needs inherited parent history. Use `delegating-pi-subagents` when you need manual CLI launches, logs, PIDs, or direct file-backed prompts.
10. Parent synthesizes results. Children advise or implement inside their contract; the parent decides.

## Micro-Task Sizing

Keep tasks narrow. Split broad areas into observable, independently verifiable outcomes.

| Too broad | Better micro-task |
|---|---|
| Frontend draft UX | Make `/sessions/new` composer visible and enabled |
| Sidebar/services | Add sidebar navigation only |
| Backend lifecycle | Make `ChatMessage.session_id` persist correctly |
| Verification | Add one failing Playwright regression |

Good parallel candidates have disjoint ownership, such as one developer owning frontend files while another owns backend files. Bad parallel candidates both touch routing, shared types, migrations, generated files, or the same tests.

## Task Template

````md
# Agent — <role>: <narrow outcome>

## Mission
<One sentence describing the observable deliverable.>

## Required context
This task must be complete for a fresh-session child. Do not rely on parent chat history.

- `path` — why it matters

## Scope and ownership
You may inspect:
- `path/or/area`

You may edit only:
- `exact/file`  <!-- omit for read-only agents -->

Do not:
- edit other files
- commit, stage, or push
- read ignored, private, credential, secret, or `.env` files
- widen scope or refactor unrelated code

## Acceptance criteria
- <observable behavior or review standard>

## Validation
Run, if practical:
```bash
<command>
```
If unavailable, report why and give next-best evidence.

## Stop rules
Stop and ask the supervisor if you find an unapproved product, architecture, API, security, data model, or scope decision.

## Final response
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
CHANGED_OR_CHECKED_FILES:
- `path` — summary
VALIDATION:
- command/evidence: result
RISKS_OR_QUESTIONS:
- item or none
````

## Runtime Choices

| Situation | Use |
|---|---|
| Contrarian risk check before work | `karen`, `context: fresh`, read-only |
| Implementation after approval | `developer`/`worker`, `context: fresh`, with complete `common-understanding.md` and explicit owned files |
| Parallel frontend/backend implementation | Fresh-session developers, separate `agent-{id}.md` files, disjoint owned files; prefer worktrees if shared contracts/types/tests may move |
| Diff or plan review | `reviewer`, `context: fresh`, read-only |
| Broad local recon | `scout`/`context-builder`, `context: fresh` |
| Multiple writers may touch the same file or generated artifact | Isolated worktrees, sequence the tasks, or do not parallelize writers |
| Long work | `async: true`, with meaningful output/progress |

## Red Flags

Stop and rewrite the delegation prompt if:

- The goal says “improve,” “handle,” “look into,” or “make better” without observable success.
- More than one writer can touch the same file, shared contract, generated artifact, migration, or broad test fixture.
- Parallel tasks lack explicit owned-file lists.
- No validation command or evidence path exists.
- The child must infer product behavior or architecture.
- The prompt includes three or more “also” clauses.
- The output format is unspecified.
- A developer prompt depends on parent chat history instead of written context.
- `fresh` vs `fork` was chosen by habit rather than purpose.

## Common Rationalizations

| Excuse | Reality |
|---|---|
| “The child can figure it out.” | Then the child becomes decision-maker. Bad monarchy. |
| “This is faster than writing a contract.” | Debugging vague delegation is slower. |
| “Reviewers do not need scope.” | Scope tells reviewers what evidence matters. |
| “Validation can wait.” | Then the handoff is a rumor, not evidence. |
| “Frontend and backend are obviously separate.” | Sometimes they share types, API contracts, tests, generated clients, or migrations. Prove ownership first. |
| “Parallel writers save time.” | They do only when file ownership is disjoint and validation catches integration drift. |

## Completion Rule

A delegation is not complete when the child finishes. It is complete when the parent has read the result, checked important claims against evidence, resolved risks, and decided the next action.
