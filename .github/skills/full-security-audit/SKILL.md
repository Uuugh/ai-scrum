---
name: full-security-audit
description: >
  Perform a comprehensive security audit. Execute all six security review skills in sequence,
  then create one consolidated audit report. Use when a project-wide security assessment is required.
  Trigger keywords include "full security audit," "comprehensive security review," "full security check," and "perform security audit."
---

# Conduct a Comprehensive Security Audit

## Preparation
- Run the Watanabe agent (`.github/agents/security.watanabe.agent.md`) as a sub-agent with the model "GPT 5.5".
- Run the Suzuki agent (`.github/agents/product-owner.suzuki.agent.md`) as a sub-agent with the model "Claude Opus 4.7".
- Run the Takahashi agent (`.github/agents/scrum-master.takahashi.agent.md`) as a sub-agent with the model "Claude Opus 4.7".

## Purpose

Assess the project-wide security posture in one pass. Execute the following six reviews in sequence and create a consolidated audit report.

## Deliverable Location
- Place the audit report directly under the root folder in `/security/reviewsXXX/`. (XXX is a sequential number starting at 001; create latest number + 1.)
- Save each review's findings in the `/security/reviewsXXX/` folder as `review-ZZZ-YYYYMMDD.md`, where ZZZ is the review target and YYYYMMDD is the date.

## Procedure

### Phase 1: Confirm Scope

Before starting the audit, verify:
- The target project's directory structure and technology stack.
- Whether Scrum artifacts exist (`scrum/` folder).
- Whether an Azure environment exists (Azure CLI login state and relevant Azure resources).
 - If the target resource groups are unclear, confirm them; do not target every RG.
- Skip reviews for resources that do not exist.

### Phase 2: Conduct Each Review

The Watanabe agent executes the following skills.
 - Record findings from each skill as work progresses.

| Order | Skill | Target | Skip Condition |
|------|--------|------|------------|
| 1 | `scrum-security-review` | Development process | Skip if the `scrum/` folder does not exist |
| 2 | `source-code-security-review` | Source code | Skip if source code such as `project/` does not exist |
| 3 | `config-security-review` | Configuration management | Skip if no Dockerfile, CI/CD, or IaC files exist |
| 4 | `threat-modeling` | Threat modeling | Always recommended |
| 5 | `supply-chain-security-review` | Supply chain | Skip if no package management files exist |
| 6 | `azure-cloud-security-review` | Azure cloud | Skip if Azure CLI is not logged in or no Azure resources exist |

### Phase 3: Create the Audit Report

After all reviews are complete, have the Watanabe agent create the consolidated report:

1. Consolidate findings from each review into a single list.
2. Assign each finding a vulnerability ID (SEC-001 onward), severity, and OWASP classification (use web search when needed).
3. Create the report using the following template:

```markdown
# Security Audit Report

## Basic Information
- Audit date: YYYY-MM-DD
- Target sprint: sprintXXX
- Audit scope: (list of reviews performed)
- Skipped items: (skipped reviews and reasons)

## Executive Summary
(Describe the overall security posture in 3–5 sentences.)

## Findings Summary
| Severity | Count |
|--------|------|
| Critical | X |
| High | X |
| Medium | X |
| Low | X |
| Info | X |

## Findings Details
(Describe each finding by category.)

## Improvement Roadmap
- **Immediate response (within 24 hours)**: Critical findings
- **Within the current sprint**: High findings
- **Next sprint**: Medium findings
- **Add to backlog**: Low findings

## Conclusion and Recommendations
(Provide the overall assessment and future actions.)
```

### Phase 4: Incorporate the Audit Report into Scrum Work

4. Based on the improvement roadmap, propose adding security PBIs to the backlog and security impediments to the impediment list to the Suzuki and Takahashi agents.
The Suzuki agent reviews the roadmap and updates PBIs in consultation with the Watanabe agent.
The Takahashi agent reviews the roadmap and updates the impediment list in consultation with the Watanabe agent.

### Phase 5: Apply Changes to the Repository

5. Use the Takahashi agent to apply the audit report and each review's findings to the main repository.
 - Finally, run git pull origin main and review and retrieve the differences.

