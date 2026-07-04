---
name: learnings
description: "Create structured feedback documenting session learnings, outcomes, and improvements"
user-invocable: true
---

# Goal

Document learnings, outcomes, and improvement opportunities from each development session, so future sessions start smarter.

# Filepath and Name

**Location:** `.agents/feedbacks/{YYYY-MM-DD-HHMM}-{kebab-case-title}.md`

- `{YYYY-MM-DD-HHMM}`: session start time — check the current date with a bash command, do not guess it
- `{kebab-case-title}`: 3-8 word summary in kebab-case

**Example:** `.agents/feedbacks/2026-01-15-1400-persistence-module-refactor.md`

> [!IMPORTANT]
> If the user provides a `feedback-file` argument, read the entire file and append new content under a `## Session {N}` header. Ensure no duplicates and maintain coherence.

# The Index

Maintain `.agents/feedbacks/INDEX.md`: one line per feedback file, newest first —

```md
- [2026-01-15 persistence-module-refactor](2026-01-15-1400-persistence-module-refactor.md) — one-sentence hook of the key lesson
```

Add your entry after writing the file. Future sessions read the index first and open only the relevant files, instead of scanning the whole folder.

# File Structure

```md
# Session Feedback: {Title}

**Date:** YYYY-MM-DD
**Task:** [description or issue link]
**Commit(s):** [`abc1234`](link), [`def5678`](link)
**Files Changed:** +X created, ~Y modified, -Z deleted

## ✅ What Went Well

- [Specific achievement with impact]
- [Tool/technique that worked well]

## ⚠️ Areas for Improvement

- [What slowed you down and why]
- [Process inefficiencies]

## 🎯 Lessons Learned

- [Technical insight gained]
- [New pattern or anti-pattern discovered]

## 🚀 Advice for Future Self

- [Actionable recommendation for next time]
- [Process to adopt or avoid]
```

## Quality Guidelines

Each entry should be:

- Specific and concrete — linked to actual code, commits, or decisions when possible
- Actionable or insightful — "run X before Y" beats "be more careful"
- **Not duplicating** lessons already documented (check `INDEX.md` first)
- **Not restating** what the repo already records: decisions belong in `docs/adr/`, vocabulary in `CONTEXT.md`, code history in git. A learning is what none of those capture.

## Before Writing

- **Read `.agents/feedbacks/INDEX.md`** (or scan the folder if missing) for recent sessions on the same topic
- **Reference the commit(s)** if work was committed during the session
- **Keep entries focused**: 3-5 bullets per section max. If a section grows beyond that, the session was likely too large
