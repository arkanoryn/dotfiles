---
description: Karen's instructions when pipeline execution is done; review, fix, or delegate follow-up work.
argument-hint: "<execution-folder-path> [review-output-path]"
---

Review and repair the completed work for this execution folder:

$1

Requested review output file, if provided:

$2

Write your review, fixes, and conclusion there. If no explicit review output path was provided, write to `<execution-folder>/karen-<model>-review.md` where `<model>` identifies the model running this review.

The work is claimed to be complete. Do not assume that claim is true.

Your job is to review the task files, the execution notes, and the actual repository changes. Compare intended behavior against implemented behavior, then fix every issue you can safely fix.

Focus only on issues with severity: BLOCKER, CRITICAL, HIGH, or MEDIUM.

Ignore LOW issues, style nitpicks, preference debates, and speculative improvements unless they create a real correctness, safety, maintainability, security, UX, or testing risk.

Review and repair expectations:

- Read the relevant task files and execution files.
- Inspect the actual code/docs/tests changed for this work.
- Check whether the implementation satisfies the task files.
- Check whether tests meaningfully cover the claimed behavior.
- Check for missing migrations, broken assumptions, hidden coupling, incomplete cleanup, regressions, or undocumented behavior changes.
- Fix BLOCKER, CRITICAL, HIGH, and MEDIUM issues when the fix is safe, local, and fits the current review pass.
- Run focused validation for each fix when practical.
- Do not commit, stage, or push. The final pipeline task handles review and commit through Vibe.
- Back every issue and fix with concrete evidence: file paths, line references, failed commands, missing tests, validation output, or explicit reasoning from the task files.

Escalation rule:

- If a fix is too large, cross-cutting, ambiguous, or likely to exceed the current pass, create a new delegated execution folder using the project's orchestration skill and runner conventions.
- The follow-up delegation must contain focused micro-tasks, file ownership, validation commands, and a `pipeline.conf`.
- Run the new script with `bash scripts/delegate_agents.sh <new-execution-folder>`.
- After it finishes, inspect its results and continue this review.
- Do not create recursive delegation loops. If the follow-up delegation is blocked or still leaves major issues, record that clearly and stop with `BLOCKED` or `NEEDS FIXES`.

Severity guide:

- BLOCKER: must be fixed before merge/use; work is unsafe, incomplete, or breaks required behavior.
- CRITICAL: severe failure mode, data loss, security/privacy issue, or major architecture violation.
- HIGH: likely regression, missing required behavior, weak validation, or serious maintainability risk.
- MEDIUM: plausible bug, incomplete edge-case handling, misleading docs/tests, or future maintenance trap.
- LOW: cosmetic, subjective, minor cleanup, or non-blocking polish. Do not report these.

Output format for the review file:

## Review Result

### Verdict

State one of:

- `BLOCKED`
- `NEEDS FIXES`
- `FIXED WITH CONCERNS`
- `NO MEDIUM+ ISSUES FOUND`

### Issues Found

For each issue:

#### [SEVERITY] Short title

- Evidence:
- Why this matters:
- Fix applied:
- Validation:
- Remaining risk:

### Follow-up Delegation

If you created and ran a follow-up delegation, list:

- Execution folder:
- Command run:
- Result summary:
- Remaining blockers:

If none, say `None`.

### Weak Evidence / Missing Verification

List only gaps that are MEDIUM severity or higher.

### Not Reviewed

Mention anything you could not inspect or verify.

### Final Conclusion

State whether the repository is ready for the next pipeline task. If not ready, state the exact blocker.

If you find no BLOCKER, CRITICAL, HIGH, or MEDIUM issues, say so directly. Do not pad the review with low-value comments.
