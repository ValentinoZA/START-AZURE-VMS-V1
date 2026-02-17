# Tech Logic – Azure VM Orchestrator

Enterprise-grade Azure Automation runbook for orchestrating Azure Virtual Machines using Managed Identity.

## 🚀 Features

- Start or Stop Azure VMs
- Resource Group targeting
- Single VM targeting
- Tag-based filtering
- Exclusion list support
- Structured logging
- Managed Identity authentication
- Azure Automation ready

## 📦 Requirements

- Azure Automation Account
- System Assigned Managed Identity enabled
- Az PowerShell Modules installed
- RBAC permissions on target VMs

## 🔧 Parameters

| Parameter | Required | Description |
|-----------|----------|------------|
| Action | Yes | Start or Stop |
| ResourceGroupName | No | Target specific resource group |
| VMName | No | Target specific VM |
| TagName | No | Filter by tag name |
| TagValue | No | Filter by tag value |
| ExcludeVMs | No | Array of VM names to exclude |

## 🏗 Example

```powershell
Action = "Stop"
TagName = "Environment"
TagValue = "Dev"
ExcludeVMs = @("DC01","SQL01")
