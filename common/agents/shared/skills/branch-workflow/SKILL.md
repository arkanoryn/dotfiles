---
name: branch-workflow
description: "Manage Git worktree lifecycle in bare repositories. Create, switch, review, and close branches with full documentation trail and safety checks. Auto-activates in bare repository contexts."
user-invocable: true
trigger: auto-detect bare repository or worktree directory
commands:
  - /branch
  - /branch {name}
  - /branch review {name}
  - /branch close {name}
---

# Branch Workflow

## Overview

Manage feature branches as Git worktrees in bare repository setups. This skill provides structured creation, context switching, review, and merge/close procedures with a documentation trail and safety checks.

**Auto-activates when:** Working directory is a bare repository or inside `{root}/worktree/{branch}/`.

**Announce at start:** "Bare repository detected. Branch workflow skill active."

## Directory Convention

```
{root}/                       # Bare repository
├── .agents/
│   └── worktree/
│       ├── {branch}.md       # Branch documentation (active)
│       └── archive/          # Closed branch documentation
│           └── {branch}.md
├── worktree/
│   ├── {branch-a}/           # Worktree for branch-a
│   │   ├── .agents/
│   │   │   └── config.md    # Branch workflow configuration
│   │   └── ...              # Project files
│   └── {branch-b}/           # Worktree for branch-b
│       ├── .agents/
│       │   └── config.md
│       └── ...
└── ...                       # Bare repository internals
```

## Configuration

The skill reads configuration from `{root}/worktree/{branch}/.agents/config.md` — this file lives in the project code (inside the worktree), not in the bare repository root. This ensures configuration is versioned with the codebase.

If missing, the skill uses sensible defaults (target branch: `dev`). It will prompt the user to create a config during the first `/branch close` operation.

Example `config.md`:
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

## Commands

### `/branch`

List all active worktrees.

**Workflow:**
1. Run `git worktree list` from the bare repository root.
2. Display active worktrees with their branch names and paths.

---

### `/branch {name}`

Switch to an existing worktree or create a new one.

**Workflow:**
1. Determine `{root}` (bare repository root).
2. Check if `{root}/worktree/{name}` exists:
   - **If exists:** Change directory and announce.
   - **If new:**
     a. Check if `{name}` exists on remote — if so, track it.
     b. Otherwise, `git worktree add {root}/worktree/{name} -b {name}`.
     c. Create `{root}/.agents/worktree/{name}.md` with metadata.
     d. Ask the user for the branch objective (populate the documentation).
     e. Change directory into the worktree.

**Example:**
```
/branch feature-auth
```

---

### `/branch review {name}`

Review work since branch creation.

**Workflow:**
1. Change directory to `{root}/worktree/{name}`.
2. Read the starting commit from `{root}/.agents/worktree/{name}.md`.
3. Show commit log and diff summary:
   ```bash
   git log --oneline {starting_commit}..HEAD
   git diff --stat {starting_commit}..HEAD
   ```
4. Review code quality and completeness vs. the branch objective.
5. Present findings with actionable items.
6. User decides: fix now or add to `TODOS.md`.
7. Update `{root}/.agents/worktree/{name}.md` with review results.

**Example:**
```
/branch review feature-auth
```

---

### `/branch close {name}`

Complete and merge branch work with safety checks.

**Workflow:**
1. Change directory to `{root}/worktree/{name}`.
2. Read `{root}/.agents/worktree/{name}.md`.
3. Check for uncommitted changes (staged and unstaged); invoke `commit-work` if needed.
4. Run `/branch review {name}` if not recently reviewed.
5. Check `TODOS.md` for unresolved items and confirm with the user.
6. Push the branch to `origin`:
   ```bash
   git push origin {name}
   ```
7. Present merge options:
   - **1)** Merge locally into `{target}` via a worktree + push.
   - **2)** Create a PR (if `gh` is available).
   - **3)** Keep the branch pushed, skip merge.
8. Execute the chosen option.
9. Cleanup:
   - `git worktree remove {root}/worktree/{name}`
   - `git branch -d {name}`
   - Archive `{root}/.agents/worktree/{name}.md` to `{root}/.agents/worktree/archive/`.

**Example:**
```
/branch close feature-auth
```

---

## Integration

- **`commit-work`:** Invoked during `/branch close` for uncommitted changes.
- **`requesting-code-review`:** Pattern used during the review phase.
- **`finishing-a-development-branch`:** Logic absorbed into `/branch close`.

## Safety Measures

- **No Auto-Merge:** Always present options and require user confirmation.
- **CI Checks:** If available, verify CI status before merging (e.g., `gh run list`).
- **Conflict Handling:** Abort and report merge conflicts; provide instructions for manual resolution.
- **User Confirmation:** Required for critical actions like merging and cleanup.

## Error Recovery

- **Worktree Creation Failure:** Fallback to tracking remote branch if local creation fails.
- **Merge Conflicts:** Provide clear instructions for manual resolution with the path to the target worktree.
- **Missing Documentation:** Recreate documentation files from Git history if possible.
- **Missing Archive Directory:** Created automatically during close.
