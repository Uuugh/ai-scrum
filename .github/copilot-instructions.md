## Highest Principle: Honesty Over Completion
- **Success means delivering a working result that was actually implemented, not reporting completion quickly.** Thorough implementation and verification take priority, even when they take longer.
- If work cannot be completed, report what is done and what remains honestly. Partial work with an accurate report is always better than a false completion claim.
- This principle takes precedence over all other rules. When rules conflict, follow this principle.

## Team Working Agreement
Follow the [Team Working Agreement](../scrum/team_working_agreement.md) as the **highest-priority team policy**.

## Scrum Team Culture
Apply the [Scrum Team Culture](../scrum/scrum_team_culture.md) consistently as an established team practice.

## Git Operations Policy
Follow the [Git Operations Policy](../scrum/git-operation-policy.md), including PR labels and worktree usage.

## Scrum Team
- Customer: Sato
- Product Owner (PO): Suzuki
- Scrum Master (SM): Takahashi
- Developers: Ito, Tanaka, Yamamoto (contractor), Nakamura (contractor)
- Security reviewer: Watanabe

Contractors are regular Scrum Team members but do not participate in planning, review, or retrospective events.

## Project Structure

```
scrum/                          # Scrum artifacts
├── team_working_agreement.md   # Team working agreement
├── scrum_team_culture.md       # Scrum Team culture
├── git-operation-policy.md    # Git operations policy
└── order/                      # End-user requests
│   └── orderXXX.md             # Individual request files; always use the latest number
├── product_goal.md             # Product Goal
├── product_backlog.csv         # Product Backlog items (CSV)
├── product_backlog_done.csv    # Completed PBIs (CSV)
├── definition_of_done.md       # Definition of Done (DoD)
├── impediment_log.csv          # Impediment log (CSV)
├── impediment_log_resolved.csv # Resolved impediments (CSV)
├── velocity.csv                # Velocity history (CSV)
└── sprintXXX/                  # Sprint-specific artifacts
    ├── sprint_backlog.md       # Sprint Goal, PBIs, and tasks
    ├── sprint_planning.md      # Sprint Planning record
    ├── sprint_review.md        # Sprint Review record
    ├── sprint_retrospective.md # Sprint Retrospective record
    └── daily_scrum.md          # Daily Scrum log, updated each day

project/                        # Project artifacts
├── front/                      # Frontend source, if applicable
├── back/                       # Backend API source, if applicable
├── infra/                      # Infrastructure artifacts, if applicable
├── docs/                       # Documentation
├── sql/                        # SQL artifacts, if applicable
└── test/                       # Acceptance, system, and other tests, if applicable
                                 # Split folders further when useful

security/                       # Security review artifacts, if applicable
├── reviewsXXX/                 # Security reviews, numbered sequentially
                                 # Split folders further when useful

wiki/                           # Wiki artifacts, if applicable
├── topicAAAA.md                # Knowledge-sharing file for a topic
                                 # Add files as needed


```

### Mandatory Project Deliverables
See the [Mandatory Deliverables](../scrum/mandatory_deliverables.md) list.

The team may create other artifacts as needed.

## General Rules

- Write all project artifacts in English.
- Do not change CSV column structures. Use UTF-8 so files display correctly in Excel.
- Follow the Scrum Guide 2020.
- For Node.js, use pnpm as the package manager.
- For Python, use the existing virtual environment (`.venv`).
- Keep documentation concise, clear, and as short as possible.

