---
description: Karen's instructions when the delegation pipeline has been generated.
argument-hint: "<execution-folder-path>"
---

Review this delegated-work orchestration as Karen:

$1 -> path to the original task folder containing `prompt.md` and `executions/`, or path to the generated `executions/` folder

The orchestration is claimed to be ready. Do not assume that claim is true.

Your job is to review the generated delegation pipeline before agents run. Find anything that would make execution unsafe, ambiguous, blocked, inefficient,
incorrectly parallelized, or likely to produce broken work.

Focus only on severity: BLOCKER, CRITICAL, HIGH, or MEDIUM.

Ignore LOW issues, wording polish, formatting nitpicks, and preference debates unless they create a real execution, correctness, maintainability, testing, security,
or coordination risk.

## Required Context

Read:

- The original `prompt.md` given to the orchestrator, if available.
- The generated `executions/` folder.
- `pipeline.conf`, if present.
- `common-understanding.md`, if present.
- Every generated agent task file.
- Referenced specs, plans, ADRs, and `.agents/instructions/*.md` files when needed.

## Review Against These Requirements

The orchestration must satisfy the original orchestrator instructions:

- Tasks are saved in an `executions/` folder beside the original `prompt.md`.
- Each task contains enough information for an intern or agent with `thinking: off` to complete it.
- Thinking level defaults to `off`.
- Thinking is increased only when justified.
- GPT 5.5 is used for review only, with `thinking: high`.
- Available parallel capacity is respected:
  - `minimax=4`
  - `mistral=3`
  - `gpt=1`
- The pipeline maximizes safe asynchronous parallelism.
- Parallel tasks have disjoint file ownership or explicit dependency ordering.
- Mistral uses Vibe by default.
- Mistral Pi is used only when medium/high thinking is required.
- Provider functions contain no broken placeholders, empty `cat ""`, fake tool calls, malformed `pi -p` arguments, or unusable snippets.
- Each agent prompt includes the relevant instructions from `.agents/instructions/*.md`.
- Reviewer/fixer agents are placed at meaningful risk gates.
- Every task has clear scope, ownership, acceptance criteria, validation, stop rules, and final reporting instructions.

## Check For

- Invalid or missing output path.
- Missing `prompt.md` traceability.
- Pipeline syntax errors.
- Invalid provider names, missing provider functions, or missing slot entries.
- DAG dependencies that reference missing agents.
- Agent files missing from the pipeline.
- Agent files present but not included in the pipeline.
- Tasks too large for their timeout or thinking level.
- Tasks that require unstated context from the parent chat.
- Tasks that require editing files outside their ownership.
- Overlapping ownership without dependency ordering.
- Over-parallelization that creates race conditions.
- Under-parallelization that wastes available safe capacity.
- Missing validation commands.
- Validation commands that cannot prove the task works.
- Missing relevant project instructions.
- Architecture, API, security, data model, or scope decisions smuggled into child tasks.
- Ambiguous acceptance criteria that would make agents guess.

Do not fix anything. Review only. Use read-only inspection commands only.

## Severity Guide

- BLOCKER: the delegated run should not start; the orchestration is structurally invalid, unsafe, missing required files, or likely to fail immediately.
- CRITICAL: severe coordination flaw, destructive instruction, security/privacy risk, or major architecture/scope decision hidden inside child tasks.
- HIGH: likely agent failure, broken dependency ordering, overlapping ownership, invalid provider setup, inadequate task context, or missing required validation.
- MEDIUM: plausible execution risk, weak acceptance criteria, suboptimal but risky parallelism, missing edge-case instruction, or maintainability trap.
- LOW: cosmetic, style, minor wording, optional improvement. Do not report these.

## Output Format

## Karen Review

### Verdict

State one of:

- `BLOCKED`
- `NEEDS FIXES`
- `NO MEDIUM+ ISSUES FOUND`

### Blockers

List only BLOCKER issues.

### Critical / High / Medium Issues

For each issue:

#### [SEVERITY] Short title

- Evidence:
- Why this matters:
- Recommended fix:

### Weak Evidence

Only include verification gaps that are MEDIUM severity or higher.

### User Forgot / Unknown Unknowns

Only include missing constraints or acceptance criteria that could realistically break delegated execution.

### Missing / Conflicting Decisions

List undocumented or conflicting architecture, product, API, security, data model, scope, or execution-strategy decisions.

### Questions Before Running Agents

Ask only questions that must be answered before running the delegation safely.

If you find no BLOCKER, CRITICAL, HIGH, or MEDIUM issues, say so directly. Do not pad the review with low-value comments.
