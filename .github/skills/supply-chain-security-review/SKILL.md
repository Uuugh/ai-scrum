---
name: supply-chain-security-review
description: >
  Verify the security of third-party components (libraries, frameworks, and tools) on which the project depends.
  Check dependency vulnerability scans, version control, automated updates, license compliance, and SBOM generation.
  Trigger keywords include "supply chain audit," "dependency audit," "SBOM audit," "license compliance audit," and "Dependabot audit."
---

# Supply Chain Security Review

## Purpose
Verify the security of third-party components (libraries, frameworks, and tools) on which the project depends.

## Instructions

1. **Perform a comprehensive dependency vulnerability scan**
   - Run the applicable commands for the technology stack:
     ```bash
     # Node.js
     pnpm audit
     pnpm audit --json > pnpm-audit.json

     # Python
     pip install pip-audit
     pip audit
     pip audit -f json > pip-audit.json

     # .NET
     dotnet list package --vulnerable
     dotnet list package --vulnerable --include-transitive

     # Generic (Trivy)
     trivy fs . --scanners vuln --format json --output trivy-vuln.json
     ```

2. **Check dependency version management**
   - Verify that lock files exist and are committed to the repository:
     - `pnpm-lock.yaml` (Node.js)
     - Pinned versions in `requirements.txt` (Python)
     - Version specifications in `*.csproj` (.NET)
   - Check whether version ranges (`^`, `~`, `>=`) are overly broad.

3. **Check automated dependency update settings**
   - Verify that `.github/dependabot.yml` exists.
   - Otherwise, verify whether an automated update tool such as Renovate is installed.
   - Check whether an auto-merging policy is configured for security updates.

4. **Verify license compliance**
   - Inventory dependency licenses and verify compatibility with the project license.
   - Check for mixed copyleft licenses such as GPL.

5. **Consider generating a Software Bill of Materials (SBOM)**
   - Verify whether an SBOM is generated and managed.
   - If none exists, propose generating it with:
     ```bash
     # Generate an SBOM with Trivy
     trivy fs . --format cyclonedx --output sbom.json
     ```
