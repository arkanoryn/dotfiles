---
name: delegating-vibe-subagents
description: Use when delegating work to Vibe subagents, especially async agents, broad review/doc tasks, long-running logs, or branch-local task files
---

# Delegating Vibe Subagents

## Overview

Delegate Vibe work as small, observable, file-backed tasks. Core principle: one agent, one narrow outcome, one owned file group, one visible output.

Vibe agents tend to produce confident, useful first drafts. Treat that as scaffolding, not truth. Every prompt must force evidence, uncertainty, and drift detection.

This skill complements `dispatching-parallel-agents`: use that to decide whether work is parallel; use this to write task files and launch Vibe safely.

## When to Use

Use when:

- The user asks to delegate via `vibe`.
- Work can be split across backend, frontend, tests, docs, research, or review.
- Agents will run asynchronously with `nohup`, outputs, or PIDs.
- You need common context plus per-agent instructions.

Do not use when:

- One focused edit is faster than orchestration.
- Tasks would edit the same files concurrently.
- Requirements are unclear; ask first.
- The task requires a shared architectural decision before work can begin.

## Core Pattern

1. Create a delegation directory:

```fish
mkdir -p .agents/plans/<area>/<task-name>
```

2. Write `common-understanding.md` with:

- Goal and expected behavior.
- Required docs/code to read.
- Hard constraints: no commits, no ignored files, no broad refactors.
- File ownership per agent.
- Evidence rules and claim grading.
- Verification commands.
- Required final reporting format.

3. Write one `agent-{id}.md` per micro-task.

Keep tasks narrow:

| Too broad         | Better micro-task                                              |
| ----------------- | -------------------------------------------------------------- |
| Frontend draft UX | Make `/sessions/new` composer visible and enabled              |
| Sidebar/services  | Add sidebar navigation only                                    |
| Backend lifecycle | Verify whether `ChatMessage.session_id` persists correctly     |
| Documentation     | Review `crates/sessions` and document only verified APIs/drift |

4. Launch only agents with independent ownership.

Use output files that are safe to read. If `*.log` is ignored by `.gitignore`, use `.output.md` instead.

```fish
set base .agents/plans/04-sessions/fix-1
nohup vibe --workdir (pwd) --trust --agent auto-approve --max-turns 10 \
  --prompt "Read @$base/common-understanding.md and @$base/agent-1.md. Execute only that task. Grade claims by evidence." \
  > $base/agent-1.output.md 2>&1 &
echo agent-1-pid=$last_pid output=$base/agent-1.output.md
```

5. Launch verification/review agents after implementation or documentation agents finish unless their files are isolated.

## Evidence Rules

Add these rules to every Vibe task that produces analysis or docs:

```text
Evidence discipline:
- Do not claim implementation status from plans, ADRs, or filenames alone.
- Verify against code before writing “implemented”, “aligned”, “complete”, or “covered”.
- Every non-obvious claim must cite one of: code path, function/type name, command output, test file, or ADR section.
- Label claims as VERIFIED, INFERRED, UNVERIFIED, or DRIFT.
- Prefer DONE_WITH_CONCERNS when any verification failed, file was unread, ADR drift exists, or behavior was inferred.
- If counts matter, compute them from source with a command; do not estimate.
- If docs and code disagree, code wins for current behavior; ADR/plan wins only as intended behavior.
```

Use this claim table in docs/reviews:

| Claim                                   | Evidence                                                 | Grade                      |
| --------------------------------------- | -------------------------------------------------------- | -------------------------- |
| `src-tauri` registers 31 commands       | `rg`/`generate_handler!` count in `src-tauri/src/lib.rs` | VERIFIED                   |
| ADR says projects live under workspaces | `.agents/DECISIONS.md` ADR-005                           | VERIFIED intended behavior |
| Projects are a separate crate           | `crates/projects/Cargo.toml`                             | DRIFT                      |

## Skeptical Review Pass

For docs, audits, and architecture reviews, each agent must do a falsification pass before final output:

1. List its top 5 strongest claims.
2. Try to disprove each claim from code or tests.
3. Downgrade unsupported claims.
4. Add drift or risk notes instead of smoothing contradictions away.

Never ask Vibe to “confirm alignment” without also asking it to find drift. That summons a golden retriever with a stamp pad.

## Task File Template

````md
# Agent N — Narrow Outcome

## Mission

One sentence. One deliverable.

## Scope

You own:

- `exact/file/path`

Do not edit other agent-owned files. If required, report `NEEDS_CONTEXT`.

## Required behavior

- Specific observable behavior.
- No extra refactors.
- No architecture decisions without coordinator approval.

## Required reads

- `AGENTS.md`
- `.gitignore`
- Relevant `.agents/DECISIONS.md` sections
- Relevant code/docs for this task

## Evidence discipline

- Verify current behavior against code.
- Mark each important claim `VERIFIED`, `INFERRED`, `UNVERIFIED`, or `DRIFT`.
- Cite paths/functions/commands for non-obvious claims.
- Use `DONE_WITH_CONCERNS` if any drift, failed command, unread relevant file, or inferred behavior remains.

## Steps

1. Verify current state.
2. If changing behavior, add or update the smallest failing test first.
3. Implement or document the minimal scope.
4. Run focused verification.
5. Perform a skeptical pass: try to disprove your own top claims.
6. Downgrade unsupported claims and report drift.

## Verification commands

```fish
exact command
```

## Final response

```text
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
CHANGED FILES:
- path
VERIFICATION:
- command: result
CLAIMS CHECKED:
- claim: evidence: VERIFIED | INFERRED | UNVERIFIED | DRIFT
DRIFT FOUND:
- bullets or none
FACTUAL FIXES / IMPLEMENTATION:
- bullets
CONCERNS:
- bullets or none
LEARNINGS:
- bullets for coordinator/future agents
```
````

## Runtime Visibility

After launching agents, immediately report:

```text
Agent 1: PID <pid>, output <path>
Agent 2: PID <pid>, output <path>
```

Give a watch command:

```fish
ps -p <pid1>,<pid2> -o pid=,stat=,etime=,cmd=
tail -f .agents/plans/<area>/<task-name>/agent-*.output.md
```

When outputs seem missing:

```fish
ps -p <pid> -o pid=,stat=,etime=,cmd= || true
ls -lah .agents/plans/<area>/<task-name>/agent-* 2>/dev/null || true
tail -80 .agents/plans/<area>/<task-name>/agent-1.output.md
```

## Sequencing Rules

| Agent type                       | Launch timing                                |
| -------------------------------- | -------------------------------------------- |
| Independent implementation       | Parallel                                     |
| Shared file implementation       | Sequential                                   |
| Documentation draft              | Parallel only with distinct owned files      |
| Documentation review             | After draft agents finish                    |
| Verification/review              | After implementation logs reviewed           |
| Shared ADR/instruction synthesis | Sequential, after all proposals are reviewed |

## Red Flags

Stop and split smaller if:

- A task owns more than 3 files.
- A task says “frontend” or “backend” without one behavior.
- Two agents may edit the same file.
- The prompt needs “also” more than twice.
- There is no focused verification command.
- Runtime is invisible except for a PID.
- The task asks for “alignment” but not “drift”.
- The expected output lacks evidence labels.
- The task asks for counts without a counting command.

## Common Mistakes

| Mistake                              | Fix                                                                         |
| ------------------------------------ | --------------------------------------------------------------------------- |
| Agents sound certain from plans/ADRs | Require code evidence and claim grades                                      |
| “DONE” despite drift                 | Require `DONE_WITH_CONCERNS` for drift, failed checks, or inferred behavior |
| Command counts are wrong             | Add `rg`/source-count command                                               |
| ADR compliance is overclaimed        | Separate “current code” from “intended ADR behavior”                        |
| Broad tasks run too long             | Split into 5-8 micro-agents                                                 |
| Missing outputs cause confusion      | Redirect to per-agent readable output files                                 |
| Verification races moving code       | Launch verifier after implementers finish                                   |
| Agents overwrite each other          | Assign explicit file ownership                                              |
| Shared ADR edits conflict            | Collect proposals first; synthesize sequentially                            |

## Max Turns Guidance

Always set `--max-turns`.

- **5-10 turns**: simple edits or focused review.
- **10 turns**: default for narrow implementation.
- **10-20 turns**: moderate code/doc audit with clear scope.
- **20+ turns**: only for exploratory audit; prefer splitting.

If agents hit turn limits, do not simply raise the cap. First narrow scope or add better required reads and verification commands.

## Documentation-Specific Prompt Add-On

Append this when delegating documentation:

```text
Write for future coding agents. Be skeptical. Current code behavior beats plans and ADRs. ADRs describe intended decisions; code may drift. Do not smooth contradictions away. If you cannot verify a claim from code, label it INFERRED or UNVERIFIED. Include exact paths/functions/commands for important claims. Prefer DONE_WITH_CONCERNS over DONE when any meaningful uncertainty remains.
```

## Real-World Baseline Failure

A six-agent documentation wave produced useful docs but overclaimed: wrong command counts, optimistic ADR alignment, and “fully implemented” claims that later review disproved. A Pi review pass fixed this by checking code, counting commands from source, and documenting drift. Future Vibe delegations must build that skepticism into the first prompt, not outsource it to cleanup.
