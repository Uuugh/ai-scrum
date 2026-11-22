---
name: sprint-review
description: Conduct a sprint review. Inspect increments, collect stakeholder feedback, determine acceptance, and adjust the product backlog. Use for the review event at the end of a sprint.
---

# Conduct the Sprint Review

Use each sub-agent started in "Preparation" according to the instructions below to conduct the sprint review.

## Preparation
- Run the Suzuki agent (`.github/agents/product-owner.suzuki.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Ito agent (`.github/agents/developer.ito.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Tanaka agent (`.github/agents/developer.tanaka.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Takahashi agent (`.github/agents/scrum-master.takahashi.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Sato agent (`.github/agents/customer.sato.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Kobayashi agent (`.github/agents/reviewer.kobayashi.agent.md`) as a sub-agent with the model "GPT-5.5".

Yamamoto and Nakamura cannot participate in the review due to contractual constraints. Proceed on the assumption that any feedback will be provided through Tanaka and Ito.

## Target Sprint
If a sprint number is supplied as an argument, target that sprint.
If no sprint number is supplied, target the latest sprintXXX in the scrum folder (XXX is sequential).

## Pre-check
1. Read `scrum/${sprint_number}/sprint_backlog.md` and identify completed and incomplete PBIs.
2. Read `scrum/product_goal.md` and review progress toward the product goal.
3. Read `scrum/definition_of_done.md` and review the Definition of Done.

## Conduct the Sprint Review

### 1. Share Sprint Goal Achievement
- Use the Takahashi agent to summarize progress toward the sprint goal.

### 2. Demonstrate and Inspect Increments
- Use the Ito and Tanaka agents to explain the demonstration of completed PBIs.
- Verify that the Definition of Done is satisfied.

### 3. Stakeholder Feedback
- Use the Sato agent to provide feedback from these perspectives:
  - Functionality: Does it operate as requested?
  - Usability: Is it easy to use?
  - Business value: Does it deliver the expected value?
  - Improvement suggestions: Ideas for making it better.

### 4. Acceptance Decision
- Use the Suzuki agent to determine acceptance for each PBI.
  - Accept: Meets the Definition of Done and clears acceptance criteria.
  - Return: Place it back in the product backlog.

### 5. Share Environmental Changes
- Share any changes in the business environment, market, or technology.

### 6. Adjust the Product Backlog
- Use the Suzuki agent to adjust the product backlog based on the review outcome.
- Add new opportunities or requests as PBIs.

### 7. Audit the Review Results
- Use the Kobayashi agent to audit the sprint review results.
  - Check that every file requiring an update was updated correctly and that nothing was missed.

### 8. Apply Changes to the Repository
- Use the Takahashi agent to merge the necessary files and apply everything to the main repository.
 - Finally, run git pull origin main and review and retrieve the differences.

## Recording
- Record the review results in `scrum/${sprint_number}/sprint_review.md`.
- Update `scrum/product_backlog.csv` (completed PBI status changes and new PBIs).
- Record sprint results in `scrum/velocity.csv`.
- Record items requiring user confirmation or questions in `scrum/${sprint_number}/ask_user.md` (as needed).

## Notes
- Do not limit the review to a presentation; conduct it as a working session.
- Collaborate with all participants to determine what should be done next.
- Preserve all necessary elements in the record while keeping it as concise as possible.
