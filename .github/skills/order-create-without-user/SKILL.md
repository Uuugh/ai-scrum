---
name: order-create-without-user
description: Create or update the request memo (scrum/order/orderXXX.md) when the manager (user) is unavailable. Use it to organize user requirements and requests and prepare work assignments for the Scrum team.
---

# Creating or Updating the Request Memo

## Preparation
- Run the Sato agent (`.github/agents/customer.sato.agent.md`) as a sub-agent with the model "Claude Opus 4.7".

## Procedure
1. Using the Sato agent, read `scrum/order/orderXXX.md` and understand its content (check only the latest XXX number).
2. Before requesting work from the Scrum team, personally identify unclear or unresolved points. Organize them based on what the manager would likely decide.
3. Update `scrum/order/orderXXX.md` in preparation for discussion with the Scrum team.

## File Update Guidelines
- Clearly document the requested work.
- Do not feel bound by the existing format; organize the content as needed and keep it easy to understand.
