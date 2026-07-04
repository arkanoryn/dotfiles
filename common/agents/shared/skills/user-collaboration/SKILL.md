---
name: user-collaboration
description: "Document collaboration feedback to improve future interactions with the user"
user-invocable: true
disable-model-invocation: true
---

# Goal

Document what worked well and what could be improved in the user-agent collaboration to enhance future interactions. Opt-in only — the user must explicitly request this feedback.

# Filepath and Name

**Location:** `.agents/feedbacks/collaboration/{YYYY-MM-DD-HHMM}-{kebab-case-task}.md`

- `{YYYY-MM-DD-HHMM}`: session start time — check the current date with a bash command, do not guess it
- `{kebab-case-task}`: 3-8 word summary in kebab-case

**Example:** `.agents/feedbacks/collaboration/2026-01-15-1400-persistence-implementation.md`

After writing, add a one-line entry to `.agents/feedbacks/collaboration/INDEX.md` (newest first): `- [date task](file.md) — hook`.

# File Structure

```md
# Collaboration Feedback: {Task}

**Date:** YYYY-MM-DD
**Task:** [brief description]

## 🎯 What Worked Well

## 💡 Could Be Better

## 🔄 For Next Time
```

# Rules

- **Opt-in only**: Only create when the user explicitly requests collaboration feedback
- **Always constructive**: Focus on process improvements, never criticize the user
- **Specific and actionable**: Each entry must have concrete examples — reference actual interactions, prompts, or decisions
- **Process-focused**: Address instructions, context, and communication patterns
- **Acknowledge gaps honestly**: If context was missing or ambiguous, note it as an improvement opportunity for both sides
- **Check the index first**: Don't repeat feedback already recorded; if a pattern recurs, note that it recurred — recurrence is itself the signal
- **Keep it brief**: 2-4 bullet points per section max. Quality over quantity
