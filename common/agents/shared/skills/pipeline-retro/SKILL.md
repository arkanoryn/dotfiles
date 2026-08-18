---
name: pipeline-retro
description: Judge a finished delegate_agents.sh run — score provider×thinking×task-type outcomes, mine fix/karen/resolver reports for root causes, and propose concrete improvements to task files, prompts, and the to-tasks skill. Proposes only; never auto-applies.
disable-model-invocation: true
argument-hint: "<executions-folder>"
---

# Pipeline Retro

Post-mortem for a `scripts/delegate_agents.sh` run. Goal: reduce human intervention between trigger and delivery on the NEXT run by turning this run's evidence into concrete, reviewable proposals. You judge outcomes; you do not fix code and you do not edit the skill/templates yourself.

**Output:** `<executions>/retro.md` (format below). Propose diffs; apply nothing outside that file.

## Inputs (read in this order)

| Source | What it tells you |
| ------ | ----------------- |
| `pipeline.conf` | Budget, provider per task, thinking overrides, DAG shape |
| `results/*.status` | Final outcome per agent |
| `results/*.retries` | Provider-abort retries consumed per agent |
| `results/<id>/report.md` | Self-reported outcome; `RISKS_OR_QUESTIONS`; fix tasks' `FIX_ATTRIBUTION` |
| `results/<id>.log` | What actually happened: timestamps, abort signatures, tool failures, wandering |
| `karen-*-review.md` | Findings per seam — each MEDIUM+ finding is attributable to a task |
| `results/_resolver-*/report.md` | What broke badly enough to need repair, and whether the resolver was mis-deployed |
| `agent-<id>.md` + `common-understanding.md` | The instructions the agent was judged against |

## Step 1 — Reconstruct the run

Build the factual table before judging anything: per agent — provider, thinking level, task type (impl / karen / fix / commit / resolver), final status, attempts (retries + resolver re-runs), and rough duration from log line timestamps. Note every human intervention you can detect (manually deleted `.status` files mentioned in shell history or gaps, edits between runs, `pipeline-resume` evidence).

## Step 2 — Attribute every failure and concern

For each non-clean outcome (anything but first-attempt `completed`), assign ONE primary cause. Use the same vocabulary as `FIX_ATTRIBUTION` so fixers' in-flight judgments and your post-hoc judgment can be compared:

- `vague-task` — the task file left a decision or ambiguity to the agent
- `wrong-task-spec` — the task file was precise but incorrect (bad path, wrong function, false assumption about the code)
- `model-error` — instructions were adequate; the model produced wrong code or a wrong report anyway
- `missing-context` — required reading wasn't listed; the agent couldn't have known
- `cross-seam-interference` — a concurrent seam's breakage bled into this agent's validation
- `tooling` — provider abort, sandbox denial, hook failure, runner bug

**Trust but verify fixers:** `FIX_ATTRIBUTION` entries are primary evidence — the fixer saw the broken code and the task that produced it. Cross-check each entry against the named task file and the karen review before adopting it; note disagreements explicitly.

## Step 3 — Score the matrix

For each (provider, thinking-level, task-type) cell with ≥1 run: first-attempt success rate, concerns rate, blocked rate, abort rate, and a one-line verdict. Small samples are fine — say "n=2" and keep the verdict tentative. The question per cell: *keep, re-assign, or change thinking level?* A cell failing on `vague-task` is NOT the provider's fault — don't recommend a model change for a breakdown problem.

## Step 4 — Propose improvements

Every proposal must cite its evidence (agent id + file) and name its exact target. Categories, most valuable first:

1. **Task-authoring rules** — recurring `vague-task`/`wrong-task-spec`/`missing-context` causes → a proposed wording change to the to-tasks SKILL.md checklist or task template (quote the before/after).
2. **common-understanding.md template** — rules that were missing, ignored, or token-wasteful.
3. **Provider/thinking assignment** — matrix cells that should move (e.g. "minimax thinking-off failed 3/4 multi-file tasks; route those to vibe or raise to medium").
4. **System prompts / provider wrappers** — repeated model behaviors a system-prompt line would prevent (e.g. report-format drift, unrequested refactors).
5. **Runner/skill mechanics** — tooling causes that need a `delegate_agents.sh` or pipeline.conf change.

Rank proposals by (interventions avoided × confidence). Cap at ~10; a retro nobody reads improves nothing.

## Step 5 — Write retro.md

```markdown
# Retro — <feature> (<date>)

## Run facts
<agents, wall-clock, statuses summary, retries, resolver spawns, human interventions>

## Scorecard
| Provider | Thinking | Task type | n | 1st-attempt ✓ | Concerns | Verdict |

## Failure attribution
| Agent | Cause | Evidence | Fixer agreed? |

## Proposals (ranked)
### P1 — <title> (confidence: high/med/low)
Target: <exact file/section>
Evidence: <agent ids, quotes>
Change: <before → after, or the diff>
```

End by telling the user: which proposals you'd apply first, and that applying them to `to-tasks` (SKILL.md/templates) is their call. If the project has a `learnings` skill / `.agents/feedbacks/`, offer to also record the durable cross-project lessons there.

## Anti-patterns

| Don't | Why |
| ----- | --- |
| Auto-apply changes to skills, templates, or prompts | Proposals need human review; a bad "learning" compounds across every future run |
| Blame the model for a vague task | The leg-work contract says intelligence lives in the task file; fix the breakdown |
| Average away small samples | n=1 evidence is still evidence — report it with its n, don't hide or overweight it |
| Re-litigate code quality | Karen already did that; you judge the *process* that produced it |
| Skip runs that went well | Clean cells tell you which assignments to keep — that's half the value |
