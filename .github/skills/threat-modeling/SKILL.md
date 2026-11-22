---
name: threat-modeling
description: >
  Systematically identify and classify threats to a system using the STRIDE method and assess risk.
  Create data flow diagrams (DFDs), identify threats, calculate risk scores, and document threat-modeling results.
  Trigger keywords include "threat modeling," "STRIDE analysis," "threat analysis," "risk assessment," and "DFD."
---

# Threat Modeling (STRIDE)

## Purpose
Systematically identify and classify threats to a system using the STRIDE method and assess risk.

## STRIDE Threat Categories

| Threat Category | Description | Recommended Mitigation |
|-----------------|-------------|------------------------|
| **S**poofing | Impersonation of an authorized user or system | Strengthen authentication (MFA, certificate authentication) |
| **T**ampering | Unauthorized modification of data or code | Integrity checks, digital signatures |
| **R**epudiation | Denial of actions | Audit logs, timestamps |
| **I**nformation Disclosure | Access to unauthorized information | Encryption, access control |
| **D**enial of Service | Disruption of service availability | Rate limiting, scaling, WAF |
| **E**levation of Privilege | Unauthorized acquisition of privileges | Least privilege, input validation, RBAC |

## Instructions

1. **Create or verify the system data flow diagram (DFD)**
   - Identify and reflect the following elements in the DFD:
     - External entities (users, external APIs, external services)
     - Processes (application components, microservices)
     - Data stores (databases, file storage, caches)
     - Data flows (communication paths, protocols)
   - Clearly delineate trust boundaries.

2. **Apply STRIDE analysis to each component**
   - Apply all six threat categories to each element in the DFD.
   - Record for each threat:
     - A concrete threat scenario
     - The expected impact (confidentiality, integrity, or availability)
     - Existing mitigations
     - Residual risk

3. **Perform risk assessment**
   - Calculate a risk score for each threat: impact (1–5) × likelihood (1–5).
   - Determine priority based on the risk score.
   - Propose immediate mitigation for Critical/High risks.

4. **Document threat-modeling results**
   - Create a report containing:
     - Target system overview and DFD
     - List of identified threats (classified by STRIDE)
     - Risk assessment results (matrix format)
     - Recommended mitigations and priorities
     - Description of residual risks

## Available Tools

| Tool | Purpose | Source |
|------|---------|--------|
| Microsoft Threat Modeling Tool | DFD creation and STRIDE analysis | https://aka.ms/threatmodelingtool |
| OWASP Threat Dragon | Open-source threat modeling | https://owasp.org/www-project-threat-dragon/ |
