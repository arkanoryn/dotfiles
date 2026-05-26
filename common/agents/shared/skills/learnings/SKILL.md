---
name: learnings-and-feedback
description: "Create structured feedback documenting session learnings, outcomes, and improvements"
user-invocable: true
---

# Goal

Document learnings, outcomes, and improvement opportunities from each development session.

# Filepath and Name

**Location:** `.agents/feedbacks/{YYYY-MM-DD-HHMM}-{kebab-case-title}.md`

**Format:**

- `{YYYY-MM-DD-HHMM}`: Session start time
- `{kebab-case-title}`: 3-8 word summary in kebab-case

**Example:** `.agents/feedbacks/2024-01-15-1400-persistence-module-refactor.md`

> [!IMPORTANT]
> If the user provides a `feedback-file` argument, read the entire file and append new content under a `## Session {N}` header. Ensure no duplicates and maintain coherence.

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
- [Collaboration moment]

## ⚠️ Areas for Improvement

- [What slowed you down and why]
- [What could have been done better]
- [Process inefficiencies]

## 🎯 Lessons Learned

- [Technical insight gained]
- [Architecture decision rationale]
- [New pattern or anti-pattern discovered]

## 🚀 Advice for Future Self

- [Actionable recommendation for next time]
- [Tool/configuration to try]
- [Process to adopt or avoid]
```

## Quality Guidelines

Each entry should be:

- Specific and concrete
- Actionable or insightful
- Linked to actual code, commits, or decisions when possible
- **Not duplicating** lessons already documented in previous feedback files (check existing files first)

## Before Writing

- **Scan `.agents/feedbacks/`** for recent sessions on the same topic to avoid repeating known lessons
- **Reference the commit(s)** if work was committed during the session
- **Keep entries focused**: 3-5 bullets per section is ideal. If a section grows beyond that, the session was likely too large
