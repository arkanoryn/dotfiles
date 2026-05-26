# Branch Workflow Skill

This skill manages Git worktrees in bare repositories, providing a structured workflow for creating, reviewing, and closing branches.

## Features

- **List Worktrees:** View all active worktrees with `/branch`.
- **Create/Switch Branches:** Create new worktrees or switch to existing ones.
- **Review Changes:** Review work since branch creation with a documentation trail.
- **Close Branches:** Safely merge and close branches with user confirmation.
- **Auto-Detection:** Activates automatically in bare repositories or worktrees.
- **Remote Tracking:** Automatically tracks remote branches if they exist.
- **Configuration:** Supports custom target branches and naming conventions.

## Directory Structure

```
{root}/                    # Bare repository
├── .agents/
│   └── worktree/          # Branch documentation
│       ├── {branch}.md   # Active branch docs
│       └── archive/       # Closed branch docs
├── worktree/              # Worktrees
│   ├── {branch-a}/       # Worktree for branch-a
│   │   └── .agents/
│   │       └── config.md # Branch workflow config (versioned with code)
│   └── {branch-b}/       # Worktree for branch-b
│       └── .agents/
│           └── config.md
└── ...                    # Bare repository internals
```

## Commands

### `/branch`

List all active worktrees.

**Example:**
```
/branch
```

### `/branch {name}`

Create or switch to a worktree for the specified branch.

**Example:**
```
/branch feature-auth
```

### `/branch review {name}`

Review changes in the specified branch since its creation.

**Example:**
```
/branch review feature-auth
```

### `/branch close {name}`

Close the specified branch, merge changes into the target branch, and clean up.

**Example:**
```
/branch close feature-auth
```

## Configuration

The skill reads configuration from `{root}/worktree/{branch}/.agents/config.md` — inside the worktree, versioned with the project code.

Example:

```markdown
# Branch Workflow Configuration

## Target Branches
- default: dev
- hotfix/*: main
- feature/*: dev

## Conventions
- naming: conventional (feature/, fix/, chore/, hotfix/)
- auto-push: true
- require-review-before-close: true
```

## Safety Measures

- **No Auto-Merge:** Always presents options and requires user confirmation.
- **CI Checks:** Verifies CI status before merging (if `gh` available).
- **Conflict Handling:** Aborts and reports merge conflicts with resolution instructions.
- **User Confirmation:** Required for critical actions like merging and cleanup.

## Integration

- **`commit-work`:** Invoked during `/branch close` for uncommitted changes.
- **`requesting-code-review`:** Pattern used during the review phase.
- **`finishing-a-development-branch`:** Logic absorbed into `/branch close`.

## Error Recovery

- **Worktree Creation Failure:** Falls back to tracking remote branch.
- **Merge Conflicts:** Provides clear instructions for manual resolution.
- **Missing Documentation:** Recreates documentation files from Git history if possible.
- **Missing Directories:** Archive directory created automatically.

## Usage

1. Navigate to your bare repository or worktree.
2. Use `/branch` to list active worktrees.
3. Use `/branch {name}` to create or switch branches.
4. Use `/branch review {name}` before closing.
5. Use `/branch close {name}` to merge and clean up.

## Requirements

- `git` installed and configured
- `envsubst` available (part of `gettext`, used for template rendering)
- `gh` CLI (optional, for PR creation)
