---
name: to-specs
description: Turn the current conversation into a specs document saved in the repo — no interview, just synthesis of what you've already discussed.
disable-model-invocation: true
---

# To Specs

Take the current conversation context (typically the end of a `/refine-with-docs` session) and produce a specs document. Do NOT interview the user — just synthesize what you already know. If something essential is genuinely undecided, list it under "Open Questions" instead of asking.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the vocabulary from `CONTEXT.md` throughout the specs, and respect the ADRs in `docs/adr/` for the area you're touching. Reference ADRs by number; if the refining session produced decisions that qualify for an ADR but none was written, write it now (see the `domain-modeling` skill's ADR rules).

2. Sketch the seams at which the feature will be built and tested. Existing seams should be preferred to new ones. Use the highest seam possible. If new seams are needed, propose them at the highest point you can. The fewer seams across the codebase, the better — the ideal number is one.

   Check with the user that these seams match their expectations. This is the only question you may ask.

3. Determine the feature folder. Follow the project's existing convention if one exists (look for `.agents/plans/` or `.agents/process/plans/`); otherwise use `.agents/plans/`. Number it sequentially: `NN-kebab-title` (scan for the highest existing `NN` and increment).

4. Write the specs to `<feature-folder>/SPECS.md` using the template below. This file is the binding spec that `to-tasks` will consume — everything an implementer needs must be in it or reachable from it (ADR references, doc links).

<specs-template>

# SPECS — <Feature title>

> One-paragraph summary of the feature from the user's perspective.

## Problem Statement

The problem the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective. Include a table of affected surfaces/sites when the feature touches several places.

## User Stories

A LONG, numbered list of user stories. Each in the format:

1. As an <actor>, I want <a feature>, so that <benefit>

This list should be extremely extensive and cover all aspects of the feature, including error paths, empty states, and removal/undo flows.

## Implementation Decisions

The decisions that were made. Can include: modules built/modified, their interfaces, architectural decisions, schema changes, API contracts, specific interactions. Reference ADRs (`docs/adr/NNNN-*.md`) rather than restating them.

Do NOT include specific file paths or code snippets — they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note it came from a prototype. Trim to the decision-rich parts.

## Testing Decisions

- What makes a good test here (test external behavior through the seams, not implementation details)
- Which modules/seams will be tested and how (unit / integration / E2E)
- Prior art: similar existing tests in the codebase

## Out of Scope

The things explicitly NOT covered by these specs, and (when known) when they will be.

## Open Questions

Decisions still owned by the user. Empty is the goal.

## Further Notes

Anything else an implementer needs.

</specs-template>

5. Tell the user the specs path and suggest the next steps: an optional Karen pass (`karen-review` skill, mode `specs`), then `/to-tasks`.
