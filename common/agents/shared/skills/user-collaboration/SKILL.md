---
name: user-collaboration-feedback
description: "Document collaboration feedback to improve future interactions with the user"
user-invocable: true
---

# Goal

Document what worked well and what could be improved in the user-agent collaboration to enhance future interactions. Opt-in only - user must explicitly request this feedback.

# Filepath and Name

**Location:** `.agents/feedbacks/collaboration/{YYYY-MM-DD-HHMM}-{kebab-case-task}.md`

**Format:**

- `{YYYY-MM-DD-HHMM}`: Session start time
- `{kebab-case-task}`: 3-8 word summary in kebab-case

**Example:** `.agents/feedbacks/collaboration/2024-01-15-1400-persistence-implementation.md`

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

- **Opt-in only**: Only create when user explicitly requests collaboration feedback
- **Always constructive**: Focus on process improvements, never criticize the user
- **Specific and actionable**: Each entry must have concrete examples
- **Process-focused**: Address instructions, context, and communication patterns
- **Link to specifics**: Reference actual interactions, prompts, or decisions when possible
- **Acknowledge gaps honestly**: If context was missing or ambiguous, note it as an improvement opportunity for both sides
- **Keep it brief**: Each section should have 2-4 bullet points max. Quality over quantity
