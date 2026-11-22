---
name: Day 3 Daily Scrum

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

Follow the instructions in `.github/skills/one-day-in-scrum/SKILL.md` to run the daily scrum and create the increment.
- Corresponding day: Day3

After completion, commit all changed files and invoke the `create_pull_request` tool to create a pull request.
