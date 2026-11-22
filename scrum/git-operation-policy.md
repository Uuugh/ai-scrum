## PR Label Rules (for GitHub Copilot Coding Agent)

If an issue has a `sprint/*` or `test/*` label, apply the same label to the PR.
The PR body must include the related issue number in the form `Fixes #<issue-number>`.

## Git Worktree Rules

Because multiple agents may work in parallel, **always use a dedicated `git worktree` for branch work**. Do not switch branches with `git checkout` in the same directory; that could disrupt another agent's work.

### Rules

- Keep the main worktree (`c:\Dev\ai-scrum-template`) on `main`. Work in a dedicated worktree created in the main repository's **parent directory**.
- One task = one worktree = one branch.
- Directory: `..\ai-scrum-template-<agent>-<topic>`; branch: `feature/<agent>/<topic>` (lowercase agent name, such as `ito`, `tanaka`, `yamamoto`, `nakamura`, or `watanabe`).
- Before starting, check for conflicts with `git worktree list`. Recreate `node_modules` and `.venv` in each worktree; do not share them.

### Procedure

```bash
# Create from the main worktree
cd /c/Dev/ai-scrum-template && git fetch origin && git pull --ff-only origin main
git worktree add ../ai-scrum-template-<agent>-<topic> -b feature/<agent>/<topic> origin/main

# Work and create the PR inside the worktree

# Clean up after merging
cd /c/Dev/ai-scrum-template
git worktree remove ../ai-scrum-template-<agent>-<topic>
git branch -d feature/<agent>/<topic>
```
