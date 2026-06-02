---
description: Use this skill when a task involves architecture, product behavior, scope boundaries, implementation strategy, cross-cutting tradeoffs, plan revisions, risky assumptions, or decisions that will be hard to reverse. Manages decision logs and ADRs in .agents/DECISIONS.md.
---

# Decision Log Skill

Use this skill when a task involves architecture, product behavior, scope boundaries, implementation strategy, cross-cutting tradeoffs, plan revisions, risky assumptions, or decisions that will be hard to reverse.

Decision records live in:

```text
.agents/DECISIONS.md
```

If a project uses a different filename such as `.agents/DECISION.md`, follow the project file if it already exists, but prefer `.agents/DECISIONS.md` for new projects.

## Core Rules

- Before proposing, revising, or implementing a non-trivial decision, read `.agents/DECISIONS.md` if it exists.
- AI MUST check the current date with a bash command before adding or updating a decision entry.
- Record durable decisions in `.agents/DECISIONS.md`.
- Do not record every tiny implementation detail.
- Do not smuggle product, architecture, API, data model, security, persistence, migration, or scope decisions into code without either referencing an existing ADR or proposing a new one.
- If a decision is not approved yet, record or present it as `🟡 Proposed` or `❓ Needs Decision`.
- If a decision changes, append a new ADR and mark the older ADR as superseded. Do not silently rewrite decision history.
- Link decisions to plans when relevant using `.agents/{feature}/plans/{iteration}-{slug}.md`.
- If task constraints say no writes, do not edit `.agents/DECISIONS.md`; instead, provide the exact ADR entry the parent/user should add.

## When to Add a Decision

Add or propose an ADR for:

- architectural choices affecting multiple modules or long-term structure;
- product behavior that users or downstream code will rely on;
- API contracts, data model changes, persistence formats, migrations, or compatibility rules;
- security, privacy, auth, permission, or trust-boundary decisions;
- choices that are hard to reverse later;
- tradeoffs where multiple plausible options were considered;
- plan revisions that materially change scope, sequencing, validation, or implementation strategy;
- assumptions that would cause expensive rework if wrong.

Do not add an ADR for:

- obvious local implementation details;
- mechanical refactors with no behavioral or architectural decision;
- temporary experiments that are explicitly throwaway;
- style choices already covered by existing conventions.

## Required ADR Template

Use the project's existing ADR format when present. If none exists, use this format:

```markdown
## ADR-XXX: Decision Title

**Status**: 🟡 Proposed | ✅ Accepted | ❌ Rejected | 🔄 Superseded by ADR-XXX | ❓ Needs Decision

**Date**: YYYY-MM-DD

**Owner**: User | Parent Agent | Planner | Karen | Developer | Reviewer

**Feature**: feature-name

**Related Plan**: `.agents/{feature}/plans/{iteration}-{slug}.md`

**Context**: What issue are we facing? What constraints matter?

**Decision**: What was decided or proposed?

**Rationale**: Why this path?

**Consequences**: What becomes easier or harder? What risks remain?

**Alternatives Considered**: What other options were considered and rejected?

**Validation / Evidence**: What evidence supports this decision?

**Related**: Links to other ADRs, docs, issues, plans, or discussions
```

## Decision Log Table

When adding an ADR, also update the decision log table if the file has one:

```markdown
| Decision | Date | Status | Notes |
| -------- | ---- | ------ | ----- |
| ADR-XXX: Decision Title | YYYY-MM-DD | 🟡 Proposed | Short note |
```

## Role-Specific Guidance

### Parent Agent

- Own final synthesis and user-facing decision authority.
- Check existing ADRs before accepting a plan that creates durable decisions.
- Ask the user when an ADR needs approval and the decision is not already authorized.
- Keep ADR updates focused; do not turn `.agents/DECISIONS.md` into a diary.

### Planner

- Read `.agents/DECISIONS.md` before planning when decisions may matter.
- Reference relevant ADRs in the plan's `Evidence Read` or `Assumptions and Decisions Needed` sections.
- Propose ADR entries for new non-trivial decisions.
- Link proposed/accepted ADRs to `.agents/{feature}/plans/{iteration}-{slug}.md`.
- Do not create a plan that requires the developer to invent unlogged durable decisions.

### Karen

- Hunt missing ADRs.
- Flag decisions smuggled in as implementation details.
- Call out user-forgotten decisions, hidden assumptions, missing stakeholders, acceptance criteria, rollout risks, migration hazards, and blame-later traps.
- Treat missing ADR coverage for a non-trivial decision as a risk or blocker depending on severity.

### Developer

- Read relevant ADRs before implementing a plan that references decisions.
- If implementation requires a new durable decision, stop and ask the supervisor instead of choosing silently.
- Report any ADR mismatch discovered during implementation.
- Do not update ADRs unless explicitly instructed or the delegated task includes decision-log maintenance.

### Reviewer

- Verify implementation aligns with relevant ADRs.
- Flag missing, stale, contradicted, or superseded ADRs.
- Treat undocumented non-trivial decisions as validation gaps or blockers.
- Check that plan revisions and implementation summaries do not conflict with `.agents/DECISIONS.md`.

## Date Rule

Before writing an ADR, run a command such as:

```bash
date +%F
```

Use that date in the ADR and decision log. Do not guess the date from memory or conversation context.

## Supersession Rule

When a decision changes:

1. Create a new ADR with the next ADR number.
2. Set the old ADR status to `🔄 Superseded by ADR-XXX` if edits are allowed.
3. In the new ADR, reference the old ADR in `Related` or `Supersedes` wording.
4. Update the decision log table.

If edits to old ADRs are not allowed, leave the old entry intact and make supersession explicit in the new ADR plus the decision log note.
