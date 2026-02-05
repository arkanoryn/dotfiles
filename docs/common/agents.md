## Agents Configuration

The agents configuration includes settings for LLM (Language Model) agents, primarily focused on Mistral Vibe. These agents provide AI-assisted workflows for coding, writing, reviewing, and other development tasks across both Arch Linux and macOS systems.

### Key Files

- **vibe/config.toml**: Main configuration file for Mistral Vibe with global settings
- **vibe/agents/**: Individual agent configurations
  - `zephyra.toml`: Zephyra agent - general-purpose coding assistant
  - `elyndra.toml`: Elyndra agent - writing and documentation specialist
  - `nyxara.toml`: Nyxara agent - code review and quality expert
  - `code_reviewer.toml`: Dedicated code reviewer agent
- **shared/prompts/**: Agent personality and behavior definitions
  - `code-reviewer_prompt.md`: Code reviewer personality and instructions
  - `ely.md`: Elyndra personality and writing guidelines
  - `nyx.md`: Nyxara personality and review standards
  - `zeph.md`: Zephyra personality and coding approach
- **shared/skills/**: Reusable skills for agent workflows
  - `brainstorming/`: Creative problem-solving and idea generation
  - `writing-clearly-and-concisely/`: Professional writing standards
  - `writing-skills/`: Advanced writing techniques
  - `test-driven-development/`: TDD methodology and practices
  - `receiving-code-review/`: Handling code review feedback
  - `requesting-code-review/`: Preparing code for review
  - `finishing-a-development-branch/`: Branch completion workflow
  - `commit-work/`: Professional commit practices

### Key Features

- **Specialized Agents**: Multiple agents optimized for different development tasks
- **Custom Personalities**: Unique prompts defining each agent's behavior and expertise
- **Modular Skills**: Reusable skills that can be applied across different agents
- **Workflow Integration**: Deep integration with development workflows
- **Cross-Platform**: Consistent behavior on both Arch Linux and macOS
- **Extensible Architecture**: Easy to add new agents and skills


### Agent Usage Examples

**Zephyra (Coding Assistant):**
\`\`\`bash
vibe --agent zephyra "Write a Python function to parse JSON with error handling"
\`\`\`

**Elyndra (Writing Specialist):**
\`\`\`bash
vibe --agent elyndra "Help me write a better commit message for these changes"
\`\`\`

**Nyxara (Code Review Expert):**
\`\`\`bash
vibe --agent nyxara "Please review this pull request for security issues"
\`\`\`


### Agent Details

**Zephyra:**
- **Role**: General-purpose coding assistant
- **Expertise**: Code generation, debugging, algorithm design
- **Personality**: Technical, precise, solution-oriented
- **Use Cases**: Implementation help, bug fixing, code optimization

**Elyndra:**
- **Role**: Writing and documentation specialist
- **Expertise**: Technical writing, documentation, prose refinement
- **Personality**: Articulate, structured, communication-focused
- **Use Cases**: Documentation, commit messages, professional communication

**Nyxara:**
- **Role**: Code review and quality expert
- **Expertise**: Code analysis, best practices, quality assurance
- **Personality**: Analytical, thorough, standards-driven
- **Use Cases**: Code reviews, quality checks, best practice enforcement

**Code Reviewer:**
- **Role**: Dedicated code review agent
- **Expertise**: Comprehensive code analysis and improvement suggestions
- **Personality**: Detailed, constructive, improvement-focused
- **Use Cases**: Formal code reviews, pull request analysis

### Skills Framework

The skills system provides reusable workflow patterns:

**Brainstorming:**
- Creative problem-solving techniques
- Idea generation and evaluation
- Multi-perspective analysis

**Writing Skills:**
- Clear and concise communication
- Technical documentation standards
- Professional writing techniques

**Development Workflows:**
- Test-driven development practices
- Code review best practices
- Branch management strategies
- Commit message standards

### Integration

Agents integrate deeply with the development environment:
- **Fish Shell**: Agent aliases and shortcuts for quick access
- **Neovim**: Code assistance and analysis within the editor
- **Tmux**: Agent workflows within terminal sessions
- **Git**: Integration with Git workflows and commit processes
- **Project Management**: Support for development lifecycle tasks

### Configuration Approach

The agent configuration follows a modular approach:
- **Global Settings**: Shared configuration in `config.toml`
- **Agent-Specific**: Individual agent personalities and behaviors
- **Reusable Skills**: Common workflow patterns applied across agents
- **Prompt Engineering**: Carefully crafted prompts for optimal agent performance

### Performance Considerations

- **Context Management**: Efficient handling of conversation context
- **Resource Usage**: Optimized for development workflows
- **Response Quality**: Tuned for technical accuracy and relevance
- **Workflow Integration**: Designed to enhance rather than disrupt development processes


### Quick Start Guide

1. **Install Mistral Vibe** and configure agents
2. **Basic Usage:**
   \`\`\`bash
   vibe "Help me implement a REST API in Python"
   vibe --agent nyxara "Help me draft a README for this project"
   \`\`\`


