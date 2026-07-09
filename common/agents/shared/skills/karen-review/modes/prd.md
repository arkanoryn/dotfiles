# Mode: prd

Input: a PRD (and the codebase it targets). **Read-only.**

- Hunt missing constraints, unstated stakeholders, absent acceptance criteria, unconsidered failure modes, migration/rollout gaps, and maintenance costs.
- Check user stories for coverage holes: error paths, empty states, permissions, concurrency, undo/rollback.
- Check the chosen seams: are they real, testable, at the highest possible level, few in number?
- Cross-reference `CONTEXT.md` and `docs/adr/`: flag terms conflicting with the glossary and decisions that contradict or lack an ADR.
- Ask what the user would blame us for later despite not specifying it.

Verdict values: `BLOCKED` | `NEEDS FIXES` | `NO MEDIUM+ ISSUES FOUND`.
