---
name: adhoc-sprint
description: Scrum team work for handling unexpected requests from users
---

## Preparation
- Run the Suzuki agent (`.github/agents/product-owner.suzuki.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Ito agent (`.github/agents/developer.ito.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Tanaka agent (`.github/agents/developer.tanaka.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Yamamoto agent (`.github/agents/contractor.yamamoto.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Nakamura agent (`.github/agents/contractor.nakamura.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Takahashi agent (`.github/agents/scrum-master.takahashi.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Kobayashi agent (`.github/agents/reviewer.kobayashi.agent.md`) as a sub-agent with the model "GPT-5.5".

## Session

- The Suzuki agent receives the user's request.
- The Suzuki agent verifies the content and assigns tasks to the appropriate sub-agents (Ito, Tanaka, Takahashi, Yamamoto, Nakamura, or Kobayashi).
 - While performing the work, sub-agents verify information against the latest data and official sources.
 - Sub-agents may process tasks in parallel.
 - If the Suzuki agent can answer directly, it responds to the user.
- The Suzuki agent determines whether it can answer the user's request based on the task results.
  - If it can, it answers the user.
  - If it cannot, it assigns additional tasks based on the results.
  - Repeat this process. If no answer is possible after three repetitions, inform the user accordingly.
- The Kobayashi agent reviews the task results and the proposed response to the user. If issues are found, it sends a correction request to the Suzuki agent. The Suzuki agent assigns any necessary correction tasks to sub-agents.
 - Repeat this process until the Kobayashi agent has no further review findings.

**When assigning tasks or preparing answers, sub-agents should share information and collaborate as needed.**

