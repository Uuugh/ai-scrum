---
name: scrum-security-review
description: >
  Verify that security is appropriately integrated into the Scrum development process.
  Review security aspects of the Definition of Done (DoD), product backlog, and sprint deliverables.
  Trigger keywords include "Scrum security audit," "process audit," "DoD security audit," and "sprint review audit."
---

# Scrum Development Process Security Review

## Purpose

Verify that security is appropriately integrated into the Scrum development process and assess whether shift-left practices—embedding security early—are in effect.

## Files to Review

- `scrum/definition_of_done.md` — Definition of Done
- `scrum/product_backlog.csv` — Product backlog
- `scrum/product_backlog_done.csv` — Completed product backlog
- `scrum/sprintXXX/sprint_backlog.md` — Sprint backlog
- `scrum/sprintXXX/sprint_planning.md` — Sprint planning record
- `scrum/sprintXXX/sprint_review.md` — Sprint review record
- `scrum/sprintXXX/sprint_retrospective.md` — Retrospective record
- `scrum/impediment_log.csv` — Impediment log
- `scrum/impediment_log_resolved.csv` — Resolved impediment log

## Instructions

1. **Review Security Items in the Definition of Done (DoD)**
   - Open `scrum/definition_of_done.md` and verify that security criteria exist.
   - Verify that it includes:
     - No hard-coded secrets.
     - Dependency vulnerability scanning.
     - Input validation and output encoding.
     - Completion of authentication and authorization tests.
   - If anything is missing, list specific items that should be added and report them.

2. **Review Security Requirements in the Product Backlog**
   - Open `scrum/product_backlog.csv` and verify whether security-related PBIs exist.
   - Check whether each PBI's `acceptance_criteria` column contains security-focused acceptance criteria.
   - Assess whether security PBI `priority` values are appropriate.
   - If required security PBIs are missing, propose additions.
   - Perform the same review for `scrum/product_backlog_done.csv`.

3. **Verify Security in Sprint Deliverables**
   - Review the latest sprint folder (`scrum/sprintXXX/`).
   - Check whether `sprint_planning.md` includes security tasks.
   - Check whether `sprint_review.md` records security inspection results.
   - Check whether `sprint_retrospective.md` discusses security-process improvements.

4. **Review Security Items in the Impediment Logs**
   - Open `scrum/impediment_log.csv` and check for impediments caused by security issues.
   - Open `scrum/impediment_log_resolved.csv` and check for resolved security-related impediments.
   - If unresolved security impediments exist, assess their impact.

5. **Assess Security Integration Across Scrum Events**
   - Use a five-level maturity scale for:
     - Security risk analysis during backlog refinement.
     - Planning of security tasks during sprint planning.
     - Sharing security blockers during daily Scrum.
     - Reporting security inspection results during sprint review.
     - Discussing security process improvements during the retrospective.
