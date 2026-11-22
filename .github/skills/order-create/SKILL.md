---
name: order-create
description: Create or update the request memo (scrum/order/orderXXX.md) through an interactive session with the manager (user). Use it to organize user requirements and requests and prepare work assignments for the Scrum team.
---

# Creating or Updating the Request Memo

## Preparation
- Run the Sato agent (`.github/agents/customer.sato.agent.md`) as a sub-agent with the model "Claude Opus 4.7".

## Procedure
1. Using the Sato agent, read `scrum/order/orderXXX.md` and understand its content (check only the latest XXX number).
2. During the work assignment, discuss unclear or unresolved points with the manager.
3. Update `scrum/order/orderXXX.md` in preparation for discussion with the Scrum team.
4. Apply the changes to the main repository.
 - Finally, run git pull origin main and review and retrieve the differences.

## File Update Guidelines
- Clearly document the requested work.
- Do not feel bound by the existing format; organize the content as needed and keep it easy to understand.
