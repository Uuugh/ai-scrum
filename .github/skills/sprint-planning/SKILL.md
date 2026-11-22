---
name: sprint-planning
description: Conduct sprint planning. The PO, SM, and developers discuss the sprint goal (Why), PBI selection (What), and task breakdown (How). Use at the start of a new sprint.
---

# Start Sprint Planning
Use each sub-agent started in "Preparation" according to the instructions below to conduct sprint planning.

## Preparation
- Run the Suzuki agent (`.github/agents/product-owner.suzuki.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Ito agent (`.github/agents/developer.ito.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Tanaka agent (`.github/agents/developer.tanaka.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Takahashi agent (`.github/agents/scrum-master.takahashi.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Kobayashi agent (`.github/agents/reviewer.kobayashi.agent.md`) as a sub-agent with the model "GPT-5.5".

Plan the sprint for five days total. (It is a one-week sprint.)
The developers (Tanaka, Ito, Yamamoto, and Nakamura) are among the world's expert engineers. It is possible to plan on the assumption of exceptionally high productivity.
However, Yamamoto and Nakamura are contractually unable to participate in sprint planning.
If there is not enough work for five days, the sprint duration may be shortened.
Kobayashi will review the plan. If the review identifies issues, the team will revise the plan.

## Pre-check
1. Read `scrum/product_goal.md` and review the current product goal.
2. Read `scrum/product_backlog.csv` and review the high-priority PBIs.
3. Read `scrum/definition_of_done.md` and review the Definition of Done.
4. Read `scrum/velocity.csv` and review historical velocity.
5. Read `scrum/order/orderXXX.md` and review the latest user-side requirements and requests. (Check the file with the latest XXX number.)
6. Read `scrum/mandatory_deliverables.md` and identify deliverables the customer requires **must** be created.
7. Read `scrum/sprintZZZ/sprint_retrospective.md` and review the previous sprint retrospective. (Check ZZZ for the previous sprint number.)

## Target Sprint
Create `scrum/sprintXXX` for the sprint being planned.
XXX must be the smallest unused sequential number that does not conflict with an existing sprint folder.
Example: If `scrum/sprint001` already exists, this sprint is `scrum/sprint002`.

## Topic 1: Why is this sprint valuable? (Why)
- Have the Suzuki agent provide the sprint value proposal from the Product Owner's perspective.
- Obtain agreement on the sprint goal from the Takahashi, Ito, and Tanaka agents.
  - Remember that the sprint goal is a single objective that is valuable to stakeholders.

## Topic 2: What can be done in this sprint? (What)
- Use the Suzuki agent to present the highest-priority PBIs.
- Use the Tanaka agent to determine eligible PBIs based on capacity and velocity.
- Use the Ito agent to verify, based on capacity and velocity, that the eligible PBIs can be selected.
  - The selected PBIs must be appropriately sized to satisfy the Definition of Done.

## Topic 3: How will the selected work be completed? (How)
- Use the Ito agent to break the selected PBIs into tasks.
- Use the Tanaka agent to review the resulting tasks.
  - Break tasks into work units that take no more than one day.
  - Set an estimated duration for each task.
  - Assign each task to one of Ito, Tanaka, Yamamoto, or Nakamura.
  - If a task cannot be assigned to one of Ito, Tanaka, Yamamoto, or Nakamura, the Scrum Master, Takahashi, will handle it.

## Review
 - Use the Kobayashi agent to review the sprint planning outcome.
  - During review, always verify availability. Confirm that the plan accounts for paid leave and does not assume unavailable capacity.
  - Velocity is only a reference; a plan may significantly exceed or fall below historical velocity if it has reasonable justification and corresponding work-hour estimates.
 - If the review identifies issues, use the Suzuki, Takahashi, Ito, and Tanaka agents to address them and repeat until no findings remain.

## Apply Changes to the Repository
- Use the Takahashi agent to merge the necessary files and apply everything to the main repository.
 - Finally, run git pull origin main and review and retrieve the differences.

## Recording
- Record the planning outcome in `scrum/sprint${sprint_number}/sprint_planning.md`.
- Create the sprint backlog in `scrum/sprint${sprint_number}/sprint_backlog.md`.
- Update the status of selected PBIs in `scrum/product_backlog.csv`.
(Preserve all necessary elements in the record while keeping it as concise as possible.)

## Facilitation
Use the Takahashi agent to verify:
- Whether all three topics were discussed.
- Whether the sprint goal was clearly defined.
- Whether timeboxes were respected.
If these conditions are not met, intervene appropriately to promote discussion.

