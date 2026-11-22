---
name: source-code-security-review
description: >
  Identify potential security vulnerabilities in source code and perform a comprehensive code review based on OWASP Top 10:2025.
  Verify secret leakage, dependency vulnerabilities, authentication and authorization, input validation, encryption, and API security.
  Trigger keywords include "code security audit review," "source code security audit," "vulnerability audit check," and "code audit."
---

# Source Code Security Review

## Purpose
Identify potential security vulnerabilities in source code and perform a comprehensive code review based on OWASP Top 10:2025.

## Review Targets
- All source code under `project/`
- Configuration files (`.env`, `config.*`, `appsettings.json`, etc.)
- Package-management files (`package.json`, `requirements.txt`, `*.csproj`, etc.)
- `.gitignore`

## Instructions

1. **Check for leaked secrets and credentials**
   - Scan the entire repository with:
     ```bash
     # Secret scan with gitleaks
     gitleaks detect --source . --verbose --report-format json --report-path gitleaks-report.json
     ```
   - Inspect `.gitignore` and verify whether it includes:
     - `.env`, `.env.local`, `.env.production`
     - `*.key`, `*.pem`, `*.pfx`
     - `appsettings.Development.json`
     - `secrets/`, `credentials/`
   - Search source code with grep for:
     ```bash
     # Search for hard-coded secrets
     grep -rn "password\s*=" project/ --include="*.ts" --include="*.js" --include="*.py" --include="*.cs"
     grep -rn "api[_-]?key\s*=" project/ --include="*.ts" --include="*.js" --include="*.py" --include="*.cs"
     grep -rn "secret\s*=" project/ --include="*.ts" --include="*.js" --include="*.py" --include="*.cs"
     grep -rn "connection[_-]?string\s*=" project/ --include="*.ts" --include="*.js" --include="*.py" --include="*.cs"
     ```

2. **Run dependency vulnerability scans**
   - Run the applicable commands for the technology stack:
     ```bash
     # For Node.js
     pnpm audit --json > npm-audit-report.json

     # For Python
     pip audit -r requirements.txt -f json > pip-audit-report.json

     # For .NET
     dotnet list package --vulnerable > dotnet-audit-report.txt
     ```
   - If Critical/High vulnerabilities exist, propose immediate remediation.
   - Check lock files (`pnpm-lock.yaml`, pinned `requirements.txt`, etc.) for fixed dependency versions.

3. **Review authentication and authorization implementations**
   - Identify and inspect authentication logic (login, token generation, password hashing).
   - Verify:
     - bcrypt, scrypt, or Argon2 is used for password hashing.
     - JWT signing algorithms are appropriate (`"none"` is disabled and RS256 is recommended).
     - Session IDs are regenerated after successful authentication.
     - Brute-force controls (rate limiting or account lockout) exist.
     - PKCE and state parameters are implemented for OAuth 2.0/OIDC.

4. **Review input validation, sanitization, and encoding**
   - Identify controller/router files for all API endpoints.
   - Search and verify these vulnerability patterns:
     - **SQL injection**: Parameterized queries or ORM usage is consistently enforced.
     - **XSS**: Output encoding is implemented; identify uses of `innerHTML` or `dangerouslySetInnerHTML`.
     - **Command injection**: Identify uses of `exec()`, `eval()`, `subprocess`, and similar APIs.
     - **SSRF**: Validate URLs in locations that send external URL requests.
     - **Path traversal**: Identify places where user input is used to construct file paths.

5. **Review cryptographic implementations**
   - Identify cryptography-related code and verify:
     - Deprecated algorithms (MD5, SHA-1, DES, RC4) are not used.
     - AES-256 or stronger encryption is used.
     - TLS 1.2 or higher is enforced.
     - Cryptographic keys are not hard-coded in source code.

6. **Review error handling and logging safety**
   - Inspect error-handling code and verify:
     - Error responses do not contain stack traces or internal information.
     - Logs do not contain personally identifiable information (PII) or confidential data.
     - Authentication events (success and failure) are logged.
     - Custom error pages are configured.

7. **Review API security**
   - Enumerate all API endpoints and verify:
     - Authentication and authorization checks are performed at every endpoint.
     - CORS configuration is appropriate (the wildcard `*` is not used).
     - Rate limiting is configured.
     - CSRF protections are implemented.
     - Responses do not contain unnecessary data (excessive data exposure).
     - Security headers (CSP, X-Frame-Options, HSTS, X-Content-Type-Options) are configured.
