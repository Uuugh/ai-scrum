---
name: backlog-refinement
description: Perform backlog refinement. Detail and split PBIs, estimate effort, clarify acceptance criteria, confirm priority, and determine Ready status. Use during ongoing product backlog improvement.
---

# Perform Backlog Refinement
Use each sub-agent started in "Preparation" according to the instructions below to perform product backlog refinement.

## Preparation
- Run the Sato agent (`.github/agents/customer.sato.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Suzuki agent (`.github/agents/product-owner.suzuki.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Ito agent (`.github/agents/developer.ito.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Tanaka agent (`.github/agents/developer.tanaka.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Takahashi agent (`.github/agents/scrum-master.takahashi.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Kobayashi agent (`.github/agents/reviewer.kobayashi.agent.md`) as a sub-agent with the model "GPT-5.5".

> Product backlog refinement is the act of breaking down and further defining product backlog items into smaller and more precise items.
> It is an ongoing activity that adds detail, order, and size.
> — Scrum Guide 2020

## Pre-check
1. Read `scrum/product_backlog.csv` and review the current product backlog.
2. Read `scrum/product_goal.md` and review the product goal.
3. Read `scrum/definition_of_done.md` and review the Definition of Done.

## Refinement Scope
Scope: If no scope is specified, refine the entire backlog.

## Perform Refinement

### 0. Create, Update, or Confirm the Product Goal

The Suzuki agent hosts the process, with support from the Ito and Tanaka agents, to create or update the product goal:
- Express the long-term vision of the product.
- The Sato agent verifies the goal's validity from the customer's perspective. Treat requirements and requests from the user side as recorded in `scrum/order/orderXXX.md`. (XXX is a sequential number; only the file with the latest number is in scope.)
- If all requests have already been considered, assume that the user has no additional requests and proceed with refinement.
- The Takahashi agent reviews the content and provides feedback from the Scrum Master's perspective.

### 1. Detail the PBIs
Using the Suzuki agent to explain each target PBI to the Sato agent, confirm and update:
- Whether the title is clear.
- Whether the description is sufficiently detailed.
- Whether it is written in user-story format.
- Whether any feedback from the Sato agent should be incorporated.

### 2. Create or Update the Definition of Done
Have the Suzuki agent define the DoD (`scrum/definition_of_done.md`) in a verifiable form:
- Each criterion must be determinable by yes/no.
- Edge cases must be considered.
Consult the Ito and Tanaka agents and add criteria from a technical perspective.
Use the Takahashi agent for review from the Scrum Master's perspective.
The Suzuki agent makes the final decision and creates or updates the DoD.

### 3. Split PBIs
Led by the Ito agent, split any PBIs that are too large:
- Assess whether each item can be completed within one sprint.
- If too large, split it into units that deliver independent value.
- Agreement from the Tanaka agent is required.
- The Suzuki agent reviews the final split.

### 4. Estimate
Led by the Ito agent and with the Tanaka agent, produce relative estimates for the PBIs:
- Estimate in story points.
- Use the team's historical performance (`scrum/velocity.csv`) as a reference. If unavailable, use an independent criterion.
- Only developers perform estimates; others must not direct the estimate.

### 5. Confirm Priority
Led by the Suzuki agent and in collaboration with the Sato agent, confirm and adjust priority:
- Consider business value, risk, and dependencies.
- Priority: Critical > High > Medium > Low

### 6. Determine Ready Status
Led by the Suzuki agent, change PBIs that meet the following criteria to "Ready":
- The description is sufficiently clear.
- Acceptance criteria are defined.
- Estimation is complete.
- Dependencies are resolved or clearly identified.
- The item can be completed within one sprint.

### 7. Audit the Refinement Results
Use the Kobayashi agent to audit the refinement results:
- Check that all required files were updated correctly and that nothing was missed.

### 8. Apply Changes to the Repository
- Use the Takahashi agent to merge the necessary files and apply everything to the main repository.
 - Finally, run git pull origin main and review and retrieve the differences.

## Recording
- The Suzuki agent updates `scrum/product_backlog.csv` (details, estimates, and status changes).
- The Suzuki agent moves completed PBIs to `scrum/product_backlog_done.csv` (and removes them from the source CSV).
- Add new PBIs to the CSV.
- If the Sato agent determines that a user request has been incorporated, record it in `scrum/order/orderXXX.md` (XXX is sequential; append the record to the file with the latest number).

## Notes
- Refinement is a continuous activity within the sprint.
- Aim to use no more than 10% of developer capacity.
- Aim to keep enough PBIs in Ready status for the next 2–3 sprints.
- Preserve all necessary elements in the record while keeping it as concise as possible.