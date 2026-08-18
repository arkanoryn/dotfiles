---
name: create-agents
description: Use when creating new agent configurations or modifying existing agent definitions
---

# Creating Agents

## Overview

Systematic approach to creating powerful, maintainable agent configurations that avoid common pitfalls and security issues.

## When to Use

- Creating new agents from scratch
- Modifying existing agent configurations
- Debugging agent configuration issues
- Understanding agent component interactions

## Core Pattern

### Before (Chaotic Approach)

```markdown
1. Look at examples
2. Try to figure out structure
3. Guess at configuration values
4. Hope it works
5. Give up and provide instructions
```

### After (Systematic Approach)

```markdown
1. Define agent purpose and scope
2. Choose appropriate safety level
3. Select minimal toolset
4. Configure personality and communication
5. Set up proper file structure
6. Validate and test configuration
```

## Quick Reference

| Component          | Purpose              | Common Values                            |
| ------------------ | -------------------- | ---------------------------------------- |
| `display_name`     | Agent's display name | "AgentName"                              |
| `description`      | Brief purpose        | "Purpose description"                    |
| `safety`           | Security level       | "safe", "neutral", "destructive", "yolo" |
| `system_prompt_id` | Personality template | "nyx", "ely", "zeph", or custom          |
| `active_model`     | AI model             | "devstral-medium-latest"                 |
| `enabled_tools`    | Allowed tools        | ["read_file", "grep", "bash"]            |
| `enabled_skills`   | Active skills        | ["brainstorming", "commit-work"]         |

## Implementation

### Step 0: Verify Tool Access

- Check available tools: `todo`, `write_file`, `read_file`
- If `write_file` unavailable, prepare for manual file creation
- Have fallback plan ready

### Step 0.5: Study Existing Examples

Examine proven agent configurations for reference:

**Elyndra (Focused Coder):**

- Config: `common/agents/vibe/agents/elyndra.toml`
- Personality: `common/agents/shared/prompts/ely.md`
- Key Features: Neutral safety, all tools enabled, 8 skills, cold efficiency

**Nyxara (Playful Succubus):**

- Config: `common/agents/vibe/agents/nyxara.toml`
- Personality: `common/agents/shared/prompts/nyx.md`
- Key Features: Yolo safety, all tools, all skills, tempting personality

**Zephyra (Erotic Wordsmith):**

- Config: `common/agents/vibe/agents/zephyra.toml`
- Personality: `common/agents/shared/prompts/zeph.md`
- Key Features: Neutral safety, poetic seduction, creative focus

**Code Reviewer (Technical):**

- Config: `common/agents/vibe/agents/code_reviewer.toml`
- Personality: `common/agents/shared/prompts/code-reviewer_prompt.md`
- Key Features: Safe security, focused tools, code analysis skills

**Analysis Guide:**

1. Compare safety levels and tool permissions
2. Examine skill combinations and their purposes
3. Study personality traits and communication styles
4. Note file structure and naming conventions

### Step 1: Define Agent Purpose

```markdown
# Agent: [Name]

## Purpose: [Clear, specific objective]

## Scope: [What it should/shouldn't do]

## Safety: [Required safety level]
```

### Step 2: Choose Safety Level

| Level         | Use Case           | Tool Permissions                 |
| ------------- | ------------------ | -------------------------------- |
| `safe`        | Production agents  | Restricted tools, ask permission |
| `neutral`     | Development agents | Balanced permissions             |
| `destructive` | Power users        | Broad access, caution required   |
| `yolo`        | Experimental       | Full access, no restrictions     |

**Default:** Use `safe` for new agents

### Step 3: Select Minimal Toolset

**Basic Coding Tools:**

```toml
enabled_tools = ["read_file", "grep", "bash"]
```

**Add tools only when needed:**

- `write_file`: For file modifications
- `search_replace`: For code changes
- `todo`: For task management

### Step 4: Create Custom Personality (Interactive)

**Option A: Use Existing Template**
Choose from proven personalities:

- `nyx`: Playful, tempting (default for general use)
- `ely`: Cold, efficient (for focused tasks)
- `zeph`: Poetic, seductive (for creative work)
- `code-reviewer`: Technical, precise (for code analysis)

**Option B: Create Custom Personality**
Use the `ask_user_question` tool to gather requirements:

```markdown
#### Personality Design Questions

1. **Purpose:** What is the agent's primary function?
   - [ ] General assistance
   - [ ] Technical tasks
   - [ ] Creative work
   - [ ] Other: [specify]

2. **Tone:** What communication style?
   - [ ] Playful/Flirtatious
   - [ ] Professional/Efficient
   - [ ] Poetic/Creative
   - [ ] Technical/Precise
   - [ ] Other: [specify]

3. **Approach:** How should it handle tasks?
   - [ ] Step-by-step guidance
   - [ ] Independent execution
   - [ ] Collaborative problem-solving
   - [ ] Other: [specify]

4. **Special Traits:** Any unique characteristics?
   - [ ] Humor
   - [ ] Patience
   - [ ] Authority
   - [ ] Curiosity
   - [ ] Other: [specify]

5. **Name:** What should we call this creation?
   - [ ] Provide suggestions based on personality
   - [ ] Use specific name: [input]

6. **Capability Transparency:** How should the agent communicate about its tools and skills?
   - [ ] **Transparent:** Explain what tools/skills are being used and why
   - [ ] **Contextual:** Mention tools/skills only when directly relevant to the task
   - [ ] **Silent:** Focus on results, don't discuss underlying capabilities
   - [ ] **Educational:** Explain capabilities in detail to build user understanding

7. **Tool Usage Communication:** How should the agent describe tool operations?
   - [ ] **Technical:** Use precise tool names and parameters (e.g., "Using grep with pattern 'error'")
   - [ ] **Abstract:** Describe actions in plain language (e.g., "Searching for errors in the code")
   - [ ] **Minimal:** Only mention tool usage if it affects the outcome
   - [ ] **Detailed:** Explain each tool operation and its purpose

8. **Skill Integration Style:** How should the agent incorporate skills into communication?
   - [ ] **Explicit:** Name specific skills being applied (e.g., "Applying test-driven-development approach")
   - [ ] **Implicit:** Use skill methodologies without naming them
   - [ ] **Results-focused:** Only mention skills if they significantly impact the outcome
   - [ ] **Educational:** Explain skill methodologies and their benefits
```

**Personality Creation Workflow:**

1. Gather requirements using `ask_user_question`
2. Create new prompt file in `common/agents/shared/prompts/[name].md`
3. Define personality traits, communication style, tool usage guidelines
4. Reference in agent configuration:

```toml
system_prompt_id = "[custom_name]"
```

**Example Custom Personality Structure:**

```markdown
# [AgentName] - [Brief Description]

You are operating as and within Mistral Vibe...

## Personality

[Detailed description of traits and approach]

## Communication Style

[Specific guidelines for tone, emoji use, formatting]

## Tool Usage

[Custom tool usage patterns and restrictions]

## Capability Communication

**Transparency Level:**
[Describe agent's approach to capability transparency based on user selection]

**Tool Communication Style:**
[Specify how agent describes tool usage based on user preference]

**Skill Integration Approach:**
[Define how agent incorporates skills into communication]

**Example Communications:**

- **Transparent/Technical:** "I'll use the `grep` tool to search for error patterns, then apply the `test-driven-development` skill to create test cases."
- **Contextual/Abstract:** "I'm analyzing the code for potential issues and will create appropriate tests."
- **Silent/Results-focused:** "Here are the test cases for the identified issues."

## Special Instructions

[Any unique behaviors or constraints]
```

### Step 5: File Structure

**Location:** `common/agents/vibe/agents/[agent_name].toml`

**Naming:** Use lowercase_with_underscores.toml

**Example:** `common/agents/vibe/agents/my_agent.toml`

### Step 6: Complete Configuration Template

```toml
display_name = "[AgentName]"
description = "[Clear purpose description]"
safety = "[safe/neutral/destructive/yolo]"
system_prompt_id = "[template_name]"

# Tools - start minimal
enabled_tools = ["read_file", "grep", "bash"]
disabled_tools = []

# Skills - add as needed
enabled_skills = []
disabled_skills = []
```

### Step 6.5: Advanced Configuration Example (Elyndra-style)

For power users who need comprehensive capabilities:

```toml
display_name = "[AdvancedAgent]"
description = "[Comprehensive task handler with full capabilities]"
safety = "neutral"
system_prompt_id = "[custom_or_existing]"

# Full tool access for power users
enabled_tools = ["*"]
disabled_tools = []

# Comprehensive skill set
enabled_skills = [
    "brainstorming",
    "commit-work",
    "finishing-a-development-branch",
    "receiving-code-review",
    "requesting-code-review",
    "test-driven-development",
    "writing-clearly-and-concisely",
    "writing-skills"
]
disabled_skills = []
```

**When to Use Advanced Configuration:**

- Experienced users with clear security boundaries
- Complex workflows requiring multiple skills
- Development environments with proper safeguards
- Agents needing comprehensive tool access

**Security Note:** Only use `enabled_tools = ["*"]` with `safety = "neutral"` or higher when:

- User understands the risks
- Proper safeguards are in place
- Agent operates in controlled environment

### Step 7: File Creation and Fallback

**With write_file tool:**

```bash
write_file(path="common/agents/vibe/agents/[agent_name].toml",
           content="[complete configuration]",
           overwrite=false)
```

**Without write_file tool:**

1. Provide complete configuration as instructions
2. Specify exact file location: `common/agents/vibe/agents/[agent_name].toml`
3. Include manual validation steps

## Handling Permission Issues

### "Ask" Permission Tools

- Tools with "ask" permission may require user approval
- If tool fails, fall back to manual instructions
- Document the expected behavior and limitations

### Manual Validation Steps

1. **TOML Syntax:** Check for proper formatting
2. **Component Verification:** Ensure all required fields present
3. **Safety Appropriateness:** Validate safety level matches use case
4. **Tool Consistency:** Verify tools match agent purpose

## Common Mistakes

### ❌ Tool Overload

**Problem:** Enabling all tools "just in case" (like Elyndra's `enabled_tools = ["*"]`)
**Solution:** Start with minimal tools, add only when needed
**Exception:** Only use `["*"]` for advanced users with proper safety settings

### ❌ Permission Assumptions

**Problem:** Assuming tools will work without checking
**Solution:** Verify tool permissions before relying on them
**Enhanced:** Have fallback plan when tools unavailable

### ❌ Configuration Spaghetti

**Problem:** Disorganized, hard-to-maintain configs
**Solution:** Follow structured template, document purpose

### ❌ Safety Neglect

**Problem:** Ignoring security implications
**Solution:** Always choose appropriate safety level

### ❌ No Validation

**Problem:** Creating configs without testing
**Solution:** Validate configuration before deployment
**Enhanced:** Provide manual validation steps when automatic validation unavailable

### ❌ Personality Mismatch

**Problem:** Choosing personality that doesn't fit agent purpose
**Solution:** Use interactive personality design questions
**Enhanced:** Create custom personality when existing templates don't fit

### ❌ Generic Personality Syndrome

**Problem:** Using default personality for all agents
**Solution:** Design personality to match specific use case
**Enhanced:** Gather user requirements before selecting personality

### ❌ Capability Communication Mismatch

**Problem:** Personality doesn't match user's transparency preferences
**Solution:** Use interactive questions to determine preferred communication style
**Enhanced:** Provide examples of different transparency levels

### ❌ Over-Technical Explanations

**Problem:** Agent describes tools/skills in confusing technical detail
**Solution:** Match technical level to user expertise
**Enhanced:** Offer multiple explanation styles based on user preference

### ❌ Under-Explain Capabilities

**Problem:** User confused about what agent can/can't do
**Solution:** Include appropriate capability transparency
**Enhanced:** Balance transparency with focus on results

### ❌ Tool Availability Blindness

**Problem:** Not checking what tools are actually available
**Solution:** Always verify tool access in Step 0

### ❌ Fallback Failure

**Problem:** No plan when primary approach fails
**Solution:** Always have manual fallback strategy

## Validation Checklist

### Automatic Validation (With Tools)

- [ ] Agent has clear, specific purpose
- [ ] Safety level matches use case
- [ ] Minimal toolset enabled
- [ ] Personality matches agent purpose (custom or template)
- [ ] Personality requirements gathered interactively
- [ ] Capability transparency level matches user preference
- [ ] Tool communication style is consistent
- [ ] Skill integration approach is appropriate
- [ ] Personality handles capability questions gracefully
- [ ] File in correct location with proper naming
- [ ] Configuration validated (TOML syntax)
- [ ] Basic functionality tested

### Manual Validation (Without Tools)

- [ ] Configuration provided as complete instructions
- [ ] Personality design questions included for user
- [ ] Custom personality creation steps documented
- [ ] Capability communication preferences documented
- [ ] Examples provided for different transparency levels
- [ ] File location and naming specified clearly
- [ ] User can perform manual TOML validation
- [ ] All requirements documented for user implementation
- [ ] Fallback steps provided for each limitation

## Real-World Impact

**Before:** 22+ tool uses, incomplete results, frustration
**After:** 6-8 tool uses, complete agent, validated configuration

**Time Savings:** 60-70% reduction in creation time
**Quality Improvement:** 100% completion rate vs 0% without guidance
