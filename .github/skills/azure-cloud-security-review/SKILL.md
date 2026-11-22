---
name: azure-cloud-security-review
description: >
  Assess the security configuration of resources deployed on Azure and verify compliance with Azure Security Benchmark v3 and CIS Benchmarks.
  Review IAM, network security, data encryption, Microsoft Defender for Cloud, logging and monitoring, and Azure Policy.
  Trigger keywords include "Azure security audit," "cloud security audit," "Azure audit," "IAM audit," and "NSG audit."
---

# Azure Cloud Security Review

## Purpose
Assess the security configuration of resources deployed on Azure and verify compliance with Azure Security Benchmark v3 and CIS Benchmarks.

## Prerequisites
- Azure CLI is installed and logged in to the target subscription.
- Reader or higher permissions are available for the target resource group.

## Instructions

1. **Inventory the Azure environment**
   - Use these commands to understand the resource landscape:
     ```bash
     # List subscriptions
     az account list --output table

     # List resource groups
     az group list --output table

     # List resources
     az resource list --resource-group <rg-name> --output table
     ```

2. **Verify IAM (Identity and Access Management)**
   - Run:
     ```bash
     # Review role assignments
     az role assignment list --all --output table

     # Review custom roles
     az role definition list --custom-role-only true --output table
     ```
   - Verify:
     - Managed identities are used.
     - Service principals use certificate authentication instead of password authentication.
     - Least privilege is applied and Owner grants are limited.
     - Guest-user access is appropriately restricted.
     - Privileged Identity Management (PIM) is enabled.

3. **Verify network security**
   - Run:
     ```bash
     # Review NSG rules
     az network nsg list --output table
     az network nsg rule list --nsg-name <nsg-name> --resource-group <rg-name> --output table

     # Review public IP addresses
     az network public-ip list --output table

     # Review VNet configuration
     az network vnet list --output table
     ```
   - Verify:
     - No unnecessary inbound rules permit SSH/RDP from 0.0.0.0/0.
     - Private endpoints are used.
     - A WAF (Web Application Firewall) is applied.
     - DDoS Protection is enabled.

4. **Verify data protection and encryption**
   - Run:
     ```bash
     # Review Key Vault
     az keyvault list --output table
     az keyvault show --name <vault-name>

     # Review storage accounts
     az storage account list --output table
     az storage account show --name <account-name> --query "{httpsOnly:enableHttpsTrafficOnly,minimumTlsVersion:minimumTlsVersion,publicAccess:allowBlobPublicAccess}"
     ```
   - Verify:
     - Public access to storage accounts is disabled.
     - HTTPS-only traffic is enforced.
     - TLS 1.2 or higher is the minimum supported version.
     - Secrets are managed in Key Vault.
     - Key Vault soft delete and purge protection are enabled.

5. **Check Microsoft Defender for Cloud**
   - Run:
     ```bash
     # Review security assessments
     az security assessment list --output table

     # Review secure score
     az security secure-score-control list --output table

     # Review regulatory compliance
     az security regulatory-compliance-standards list --output table
     ```
   - Verify:
     - Defender for Cloud is enabled across all subscriptions.
     - Secure score is at least 70%.
     - No unresolved Critical/High recommendations remain.

6. **Verify logging, monitoring, and alerts**
   - Run:
     ```bash
     # Review diagnostic settings
     az monitor diagnostic-settings list --resource <resource-id> --output table

     # Review Log Analytics workspaces
     az monitor log-analytics workspace list --output table

     # Review activity log alerts
     az monitor activity-log alert list --output table
     ```
   - Verify:
     - Diagnostic logs are enabled for major resources.
     - Logs are aggregated in a Log Analytics workspace.
     - Alerts are configured for security events.
     - Log retention is appropriate (minimum 90 days recommended).

7. **Verify governance with Azure Policy**
   - Run:
     ```bash
     # Review policy assignments
     az policy assignment list --output table

     # Review policy compliance status
     az policy state summarize --output table
     ```
   - Verify:
     - Security-related policies are assigned.
     - The number and nature of non-compliant resources are identified and remediation is proposed.
