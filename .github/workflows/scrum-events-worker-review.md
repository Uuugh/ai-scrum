---
on:
  workflow_call:
    inputs:
      payload:
        description: JSON payload passed automatically by call-workflow
        required: false
        type: string
      phase_name:
        description: Fixed phase name used to make the artifact prefix unique
        required: true
        type: string
      pr_branch_name:
        description: PR branch name targeted for continued updates
        required: true
        type: string
      pull_request_number:
        description: PR number targeted for continued updates
        required: true
        type: string
  steps:
    - id: expose_inputs
      shell: bash
      env:
        PHASE_NAME: ${{ inputs.phase_name }}
        PR_BRANCH_NAME: ${{ inputs.pr_branch_name }}
        PULL_REQUEST_NUMBER: ${{ inputs.pull_request_number }}
      run: |
        {
          printf 'phase_name=%s\n' "$PHASE_NAME"
          printf 'pr_branch_name=%s\n' "$PR_BRANCH_NAME"
          printf 'pull_request_number=%s\n' "$PULL_REQUEST_NUMBER"
        } >> "$GITHUB_OUTPUT"
description: Worker that runs sprint review in an independent context and applies it to the existing PR branch
engine:
  id: copilot
  model: claude-opus-4.6
imports:
  - uses: shared/apm.md
    with:
      packages:
        - shyamagu-ms/ai-scrum/.github/skills/sprint-review
        - shyamagu-ms/ai-scrum/.github/agents/customer.sato.agent.md
        - shyamagu-ms/ai-scrum/.github/agents/product-owner.suzuki.agent.md
        - shyamagu-ms/ai-scrum/.github/agents/developer.ito.agent.md
        - shyamagu-ms/ai-scrum/.github/agents/developer.tanaka.agent.md
        - shyamagu-ms/ai-scrum/.github/agents/scrum-master.takahashi.agent.md
timeout-minutes: 360
permissions:
  contents: read
  pull-requests: read
tools:
  edit:
  bash: true
  github:
    toolsets: [pull_requests]
checkout:
  ref: ${{ inputs.pr_branch_name }}
  fetch-depth: 0
  fetch: ["*"]
safe-outputs:
  push-to-pull-request-branch:
    target: ${{ inputs.pull_request_number }}
    title-prefix: "[ai-sprint] "
    max: 1
    if-no-changes: warn
    github-token: ${{ secrets.GH_AW_GITHUB_TOKEN }}
    protected-files: allowed
jobs:
  pre-activation:
    outputs:
      phase_name: ${{ steps.expose_inputs.outputs.phase_name }}
      pr_branch_name: ${{ steps.expose_inputs.outputs.pr_branch_name }}
      pull_request_number: ${{ steps.expose_inputs.outputs.pull_request_number }}
---

# Sprint Review Worker

This worker must use only the current repository state and `${{ needs.pre_activation.outputs.phase_name }}`, `${{ needs.pre_activation.outputs.pr_branch_name }}`, and `${{ needs.pre_activation.outputs.pull_request_number }}` as evidence. Do not rely on prior conversations or the internal reasoning of other workers.

The role of this worker is to run the `/sprint-review` skill and add the changes to the existing PR.

# Execution Rules

1. Update only **PR #`${{ needs.pre_activation.outputs.pull_request_number }}`**. Do not search for or update any other PR.
2. When using `push_to_pull_request_branch`, always set **`pull_request_number` to `${{ needs.pre_activation.outputs.pull_request_number }}`** and **`branch` to `${{ needs.pre_activation.outputs.pr_branch_name }}`**.
3. Never create a new PR.
4. The change scope is **the entire repository**. Update existing files or create new files as needed.
5. **Artifact updates are mandatory in this workflow.** Update at least one existing file and call `push_to_pull_request_branch` exactly once.
6. **Do not finish successfully with `noop`.** If no diff can be created, do not treat it as success; report missing information or blockers with `missing_data`.
7. If `ask_user.md` must be created, keep the record concise and in English.

# Work

1. If needed, fetch the remote branch and switch to `${{ needs.pre_activation.outputs.pr_branch_name }}`.
2. Run the `/sprint-review` skill.
3. Review the changes and push them with `push_to_pull_request_branch` to **PR #`${{ needs.pre_activation.outputs.pull_request_number }}`**.

