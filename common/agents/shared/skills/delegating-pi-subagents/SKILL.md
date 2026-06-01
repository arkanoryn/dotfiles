---
name: delegating-pi-subagents
description: Use when delegating work to Pi subagents, especially multiple async agents, broad implementation tasks, long-running logs, or branch-local task files
---

# Delegating Pi Subagents

## Overview

Delegate Pi work as small, observable, file-backed tasks. Core principle: one agent, one narrow outcome, one owned file group, one log.

This skill complements `dispatching-parallel-agents`: use that for deciding whether work is parallel; use this for writing Pi task files and launching safely.

## When to Use

Use when:

- The user asks to delegate to agents/subagents via `pi`.
- Work can be split across backend, frontend, tests, docs, or review.
- Agents will run asynchronously with `nohup`, logs, or PIDs.
- You need common context plus per-agent instructions.

Do not use when:

- One focused edit is faster than orchestration.
- Tasks would edit the same files concurrently.
- Requirements are unclear; ask first.

## Core Pattern

1. Create a delegation directory:

```fish
mkdir -p .agents/plans/<area>/<fix-name>
```

2. Write `common-understanding.md` with:

- Goal and expected behavior.
- Required docs to read.
- Hard constraints: no commits, no ignored files, no broad refactors.
- File ownership per agent.
- Verification commands.
- Required final reporting format.

3. Write one `agent-{id}.md` per micro-task.

Keep tasks narrow:

| Too broad | Better micro-task |
|---|---|
| Frontend draft UX | Make `/sessions/new` composer visible and enabled |
| Sidebar/services | Add sidebar navigation only |
| Backend lifecycle | Make `ChatMessage.session_id` persist correctly |
| Verification | Add one failing Playwright regression |

4. Launch only agents with independent file ownership.

```fish
set base .agents/plans/04-sessions/fix-1
nohup pi --provider minimax --model minimax-m2.7 \
  -p @$base/common-understanding.md @$base/agent-1.md \
  "Read common-understanding then implements agent-1. Backend only." \
  > $base/agent-1.log 2>&1 &
echo agent-1-pid=$last_pid
```

5. Launch verification agents after implementation agents finish unless tests are isolated from moving code.

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

## Steps

1. Verify current state.
2. Add or update the smallest failing test if changing behavior.
3. Implement minimal fix.
4. Run focused verification.

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
SUMMARY:
- bullets
CONCERNS:
- bullets or none
```
````

## Runtime Visibility

After launching agents, immediately report:

```text
Agent 1: PID <pid>, log <path>
Agent 2: PID <pid>, log <path>
```

Give a watch command:

```fish
ps -p <pid1>,<pid2> -o pid=,stat=,etime=,cmd=
tail -f .agents/plans/<area>/<fix-name>/agent-*.log
```

When logs seem missing, check both PID and file:

```fish
ps -p <pid> -o pid=,stat=,etime=,cmd= || true
ls -lah .agents/plans/<area>/<fix-name>/agent-*.log 2>/dev/null || true
tail -80 .agents/plans/<area>/<fix-name>/agent-1.log
```

## Sequencing Rules

| Agent type | Launch timing |
|---|---|
| Independent implementation | Parallel |
| Shared file implementation | Sequential |
| Verification/review | After implementation logs reviewed |
| Cleanup/refactor | After verification identifies exact need |

## Red Flags

Stop and split smaller if:

- A task owns more than 3 files.
- A task says “frontend” or “backend” without a single behavior.
- Two agents may edit the same file.
- The prompt needs “also” more than twice.
- There is no focused verification command.
- Runtime would be invisible except for a background PID.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Broad tasks run too long | Split into 5-8 micro-agents |
| Missing logs cause confusion | Always redirect to per-agent `.log` files |
| Verification races moving code | Launch verifier after implementers finish |
| Agents overwrite each other | Assign explicit file ownership |
| Prompt too long for `pi -p` | Put details in files; keep CLI message one line |

## Real-World Trigger

A session repair delegation used three broad agents: backend, frontend UX, sidebar/services. It worked, but runtime visibility was poor and frontend tasks were too large. Future delegations should prefer narrower micro-agents plus explicit status commands.
