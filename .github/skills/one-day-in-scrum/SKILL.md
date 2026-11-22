---
name: one-day-in-scrum
description: Conduct a daily Scrum and create increments. Confirm progress toward the sprint goal, adjust the plan for the next day, identify impediments, and create increments. Use for one development cycle during a sprint.
---

# Daily Scrum and Increment Creation
Use each sub-agent started in "Preparation" according to the instructions below.
(1) Hold the daily Scrum with everyone, then (2) have each person create increments, (3) address and report audit findings, and (4) apply the code to the repository.

## Preparation
- Run the Ito agent (`.github/agents/developer.ito.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Tanaka agent (`.github/agents/developer.tanaka.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Yamamoto agent (`.github/agents/contractor.yamamoto.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Nakamura agent (`.github/agents/contractor.nakamura.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Takahashi agent (`.github/agents/scrum-master.takahashi.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Kobayashi agent (`.github/agents/reviewer.kobayashi.agent.md`) as a sub-agent with the model "GPT-5.5".

---

## (1) Conduct the Daily Scrum

### Target Sprint
Target the latest sprintXXX in the scrum folder (XXX is sequential; check only the latest one).
 
### Pre-check
1. Read `scrum/${sprint_number}/sprint_backlog.md` and check the current state of the sprint backlog.
2. Confirm the sprint goal.

### Conduct the Daily Scrum

Use the Ito, Tanaka, Yamamoto, and Nakamura agents to check each member's status from the following perspectives:

1. **What did you do yesterday?** — What did you accomplish toward the sprint goal?
2. **What will you do today?** — What will you work on toward the sprint goal?
3. **Impediments** — Is anything preventing achievement of the sprint goal?

**Ask each member to report briefly and concisely.**

#### Inspect Progress
- Assess overall progress toward the sprint goal.
- Update the task statuses in the sprint backlog.
- Update the burndown.

#### Handle Impediments
- If impediments are identified, use the Takahashi agent to record them in `scrum/impediment_log.csv`.
- Check the resolution status of existing impediments.
- Resolve impediments that can be addressed immediately. For those that cannot, address them in the retrospective.

#### Recording
- Append today's daily Scrum record to `scrum/sprint${sprint_number}/daily_scrum.md`.
- Update task statuses in `scrum/sprint${sprint_number}/sprint_backlog.md`.
**Record both daily_scrum.md and sprint_backlog.md without omitting necessary elements, but keep the content concise.**

#### Adapt
- If the plan needs adjustment, update the sprint backlog.
- If the sprint goal is affected, consider renegotiating the scope with the Suzuki agent.
 ※To renegotiate with the Suzuki agent, run the Suzuki agent (`.github/agents/product-owner.suzuki.agent.md`) as a sub-agent with the model "Claude Opus 4.7".

---

## (2) Create Increments
- Based on the daily Scrum, Tanaka, Ito, Yamamoto, and Nakamura create increments in parallel.
 - While creating increments, minimize long-running tasks such as explorer tasks.
 - Review [definition_of_done.md](../../../scrum/definition_of_done.md) while working and ensure that each increment meets the Definition of Done.

As soon as each agent finishes creating an increment, the Kobayashi agent reviews it.
 - The primary focus of the review is confirming that work was reliably completed according to the plan.
  - Real environment operations and creation tasks have been falsely claimed in the past; verify these especially carefully.
 - If a problem is found, immediately start the responsible agent and have it perform the correction or additional work.

---

## (3) Report
- After the Tanaka, Ito, Yamamoto, and Nakamura agents create their increments, provide a concise report based on the outcome of (1).

## (4) Apply Code to the Repository
- Use the Takahashi agent to merge the necessary files and apply everything to the main repository.
 - Check dependencies among the differences and integrate or adjust code as needed.
 - Finally, run git pull origin main and review and retrieve the differences.

