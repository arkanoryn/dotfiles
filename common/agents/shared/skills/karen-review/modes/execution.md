# Mode: execution

Input: an execution folder whose agents have run (`results/` populated), plus the repository. Compare intended behavior (specs, task files) against implemented behavior (actual code, tests, reports). **You may fix, within limits below.**

## Where you sit in the pipeline

A seam runs `tasks → karen-<seam> → fix-<seam> → commit-<seam>`. You review BEFORE the seam is committed; your safe fixes and the fix task's changes are committed together by `commit-<seam>`. Therefore:

- **Never commit, stage, or push** — that is `commit-<seam>`'s job.
- **Edit only the seam's owned files** (the ownership-map rows of the tasks you review). Other seams may be running concurrently; touching their files creates the exact race the ownership map prevents. If a needed fix lies outside the seam's files, record it as an issue and report `BLOCKED` instead of editing.

## Review

- Read the task files, the agent reports, and the actual diffs — reports can lie; verify against the code.
- Check tests meaningfully cover the claimed behavior; check for missing migrations, hidden coupling, incomplete cleanup, regressions, undocumented behavior changes.
- If a resolver ran (`results/_resolver-*/`), read its report: verify its repair was minimal and didn't mask a real defect in the task's output.
- Fix MEDIUM+ issues when the fix is safe, local, within the seam's owned files, and fits this pass. Run focused validation for each fix.
- If a fix is too large, cross-cutting, or ambiguous: create a follow-up execution folder using the project's `to-tasks` conventions, run `bash scripts/delegate_agents.sh <folder>`, inspect the result, then finish this review. Never create recursive delegation loops — if the follow-up still leaves major issues, record it and stop with `BLOCKED`.

## karen-final only

Seam commits already exist when you run. Additionally verify commit hygiene: `git log --stat` for each `commit-<seam>` commit — it must contain exactly that seam's owned files (no foreign files swept up, nothing owned but missing), and messages must describe the seam's actual change. Verify the seam reviews' conclusions instead of trusting them.

Verdict values: `BLOCKED` | `NEEDS FIXES` | `FIXED WITH CONCERNS` | `NO MEDIUM+ ISSUES FOUND`.
