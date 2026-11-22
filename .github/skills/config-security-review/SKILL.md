---
name: config-security-review
description: >
  Verify that application configuration files and deployment configurations have no security issues.
  Review Docker, CI/CD pipelines, IaC (Terraform/Bicep), and environment configuration security.
  Trigger keywords include "configuration security audit," "Docker security audit," "CI/CD security audit," and "IaC security audit."
---

# Configuration and Deployment Security Review

## Purpose
Verify that application configuration files and deployment configurations have no security issues.

## Review Targets
- Docker files (`Dockerfile`, `docker-compose.yml`)
- CI/CD configuration (`.github/workflows/*.yml`)
- IaC files (`*.tf`, `*.bicep`, `*.arm.json`)
- Environment configuration (`.env.example`, `appsettings.json`)

## Instructions

1. **Verify Docker file security**
   - When a `Dockerfile` exists, confirm:
     - The base image is official and minimal (Alpine is recommended).
     - The container runs as a non-root, non-privileged user.
     - No unnecessary packages or tools are included.
     - Multi-stage builds are used.
   - Run container image vulnerability scans:
     ```bash
     # Filesystem scan with Trivy
     trivy fs . --severity CRITICAL,HIGH --format json --output trivy-fs-report.json

     # Container image scan (if the image exists)
     trivy image <image-name> --severity CRITICAL,HIGH
     ```

2. **Verify CI/CD pipeline security**
   - Inspect workflow files under `.github/workflows/`.
   - Verify:
     - Secrets are managed by GitHub Secrets and are not hard-coded.
     - Third-party GitHub Actions come from trusted sources (official or verified creators).
     - Action versions are pinned to commit hashes or specific tags.
     - SAST, SCA, and secret scanning are integrated into the pipeline.
     - Branch protection rules are configured.
     - Code review is required.

3. **Scan IaC files**
   - For Terraform/Bicep files, run:
     ```bash
     # IaC scan with Trivy (successor to tfsec)
     trivy config . --severity CRITICAL,HIGH --format json --output trivy-iac-report.json

     # IaC scan with Checkov
     checkov -d . --output json > checkov-report.json
     ```
   - Verify these IaC best practices:
     - Public access to resources is minimized.
     - Encryption is enabled by default.
     - Network access is restricted to the minimum necessary.
     - Tagging and resource naming conventions are consistent.

4. **Verify environment configuration security**
   - If `.env.example` exists, ensure it contains no actual values or secrets.
   - Inspect configuration files such as `appsettings.json`:
     - Debug mode is disabled in production.
     - Secrets are not directly embedded in connection strings.
     - Log levels are appropriate for production (DEBUG is prohibited).
