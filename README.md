# MS-Exchange-Powershell-Scripts

# 📬 PowerShell Scripts for Distribution List (DL) and Shared Mailbox Management
This repository contains a collection of PowerShell scripts used for automating the management of **Distribution Lists (DLs)**, **Shared Mailboxes**, and **Outlook Folder Delegation** within a Microsoft 365 environment via **Exchange Online** and **Azure AD**.

## 📂 Contents

| Script Name                | Description                                                                 |
|---------------------------|-----------------------------------------------------------------------------|
| `Create-DL.ps1`            | Creates a new Distribution List with specified members and owners          |
| `Update-DL.ps1`            | Updates the members or properties of an existing DL                        |
| `Delete-DL.ps1`            | Deletes an existing DL from the tenant                                     |
| `Change-DLOwner.ps1`       | Updates or replaces the owners of a specified DL                           |
| `Create-SharedMailbox.ps1` | Creates a new shared mailbox and configures basic settings                 |
| `Add-OutlookDelegation.ps1`| Assigns folder-level delegation (Read/Write) for a mailbox to another user |

## ✅ Prerequisites

### Install Exchange Online PowerShell module

```powershell
Install-Module -Name ExchangeOnlineManagement


# The values for AppID, CertificateThumbprint, and Organization are securely stored as system properties in ServiceNow.
# These values are passed into this PowerShell script via IntegrationHub Flow Designer Action inputs.
# You can access them in the script using the '$' symbol followed by the variable name (e.g., $AppId, $CertificateThumbprint, $Organization).

