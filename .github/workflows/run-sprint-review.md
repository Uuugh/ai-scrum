---
name: Sprint Review

on:
  workflow_dispatch:
  workflow_call:

engine:
  id: copilot
  model: claude-opus-4.6

timeout-minutes: 360

permissions: read-all

network:
  allowed:
    - defaults

tools:
  edit:
  bash: true
  github:

safe-outputs:
  create-pull-request:
    draft: true
    protected-files: fallback-to-issue

---

Follow the instructions in `.github/skills/sprint-review/SKILL.md` to perform the Sprint Review.

After completion, commit all changed files and invoke the `create_pull_request` tool to create a pull request.
