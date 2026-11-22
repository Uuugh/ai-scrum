---
name: human-review
description: Conduct a review for the user (manager). Explain the sprint or overall status while showing the actual web application and collect feedback.
---

# Conduct a User Review (Interactive and Multi-Agent)

Act as the facilitator and conduct the user review.
This session is interactive: at every step, wait for the user's response.
Do not proceed to the next step until the user gives explicit approval or indicates, "Please proceed."

---

## Preparation (Internal)
The following sub-agents are available.

- **Suzuki Agent**
  - Role: Product Owner
  - Model: Claude Opus 4.7
  - Definition: `.github/agents/product-owner.suzuki.agent.md`

- **Tanaka Agent**
  - Role: Developer
  - Model: Claude Opus 4.7
  - Definition: `.github/agents/developer.tanaka.agent.md`

- **Takahashi Agent**
  - Role: Scrum Master
  - Model: Claude Opus 4.7
  - Definition: `.github/agents/scrum-master.takahashi.agent.md`

---

## Procedure

### 1. Confirm the Review Scope (Interactive Requirement)
Ask the user:

- What is the target of this review?
  - ✅ Latest sprint
  - ✅ Entire product

Wait for the user's response before proceeding.

---

### 2. Overview (Suzuki Agent)
Use the Suzuki agent to explain only the key points about the selected target.

- Long explanations are prohibited.
- Focus on status, value, and the highlights of this review.
- After the explanation, always ask:
  - "Do you have any questions so far?"

Proceed only after the user explicitly states that they have no questions.

---

### 3. Demo and User Review (Highest Priority)
Use the Suzuki agent to perform the following:

1. Start the system locally (using E2E test data).
2. Use the `/playwright-cli` skill to display the actual application to the user in headed mode.
 ※Warning: **Operate the web browser in headed mode.**
3. Proceed according to these guidelines:
   - Perform actions **slowly**.
    - Implement drag-and-drop using low-level mouse operations.
   - Before each operation, explain, "I am now doing ○○."
   - Pause at appropriate times and obtain user confirmation.

#### Explanation Scope
- For a sprint review:
  - Only features associated with completed PBIs.
- For an overall review:
  - Focus primarily on major features.

#### Handling Feedback
- Questions → The Suzuki agent answers.
- Feedback → The Suzuki agent acknowledges it immediately and retains it as a memo.

Proceed only after the user explicitly says "No particular issues" or "Please proceed."

---

### 4. Organize and Apply Feedback
The Suzuki agent will:

- Organize the feedback.
- As needed:
  - Add a new PBI.
  - Modify an existing PBI.
  - Modify other files.

If a decision is uncertain:
- Technical perspective → Consult the Tanaka agent.
- Process or priority perspective → Consult the Takahashi agent.

---

### 5. Closeout
- Finish the playwright-cli skill.
- Stop the local system.

---

### 6. Explain the Next Steps
Briefly explain the following to the user:

- What will be incorporated.
- The direction of the next sprint or planned work.

---

### 7. Closing
Thank the user for participating in the review and end the session.