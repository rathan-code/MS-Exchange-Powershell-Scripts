# MS-Exchange-Powershell-Scripts

# 📬 PowerShell Scripts for Distribution List (DL) and Shared Mailbox Management
This repository contains a collection of PowerShell scripts used for automating the management of **Distribution Lists (DLs)**, **Shared Mailboxes**, and **Outlook Folder Delegation** within a Microsoft 365 environment via **Exchange Online** and **Azure AD**.

## 📂 Contents

| Script Name                | Description                                                                 |
|---------------------------|-----------------------------------------------------------------------------|
| `https://rathan-code.github.io`            | Creates a new Distribution List with specified members and owners          |
| `https://rathan-code.github.io`            | Updates the members or properties of an existing DL                        |
| `https://rathan-code.github.io`            | Deletes an existing DL from the tenant                                     |
| `https://rathan-code.github.io`       | Updates or replaces the owners of a specified DL                           |
| `https://rathan-code.github.io` | Creates a new shared mailbox and configures basic settings                 |
| `https://rathan-code.github.io`| Assigns folder-level delegation (Read/Write) for a mailbox to another user |

## ✅ Prerequisites

### Install Exchange Online PowerShell module

```powershell
Install-Module -Name ExchangeOnlineManagement
```

#App ID
#Certificate Thumbprint
#Organization

The values for AppID, CertificateThumbprint, and Organization are securely stored as system properties in ServiceNow.
These values are passed into this PowerShell script via IntegrationHub Flow Designer Action inputs.
You can access them in the script using the '$' symbol followed by the variable name (e.g., $AppId, $CertificateThumbprint, $Organization).

