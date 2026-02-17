<#
.SYNOPSIS
Tech Logic – Azure VM Orchestrator

.DESCRIPTION
Enterprise-grade Azure Automation runbook developed by Tech Logic.
Provides intelligent orchestration for Azure Virtual Machines 
using managed identity authentication.

Supports:
• Tag-based targeting
• Resource group filtering
• Individual VM targeting
• Include/Exclude lists
• Start or Stop mode
• Structured logging
• Cost-optimization scheduling

.AUTHOR
Tech Logic

.VERSION
1.0.0

.LAST UPDATED
2026-02-16

.COPYRIGHT
© 2026 Tech Logic. All rights reserved.

#>


param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("Start","Stop")]
    [string]$Action,

    [string]$ResourceGroupName,

    [string]$VMName,

    [string]$TagName,

    [string]$TagValue,

    [string[]]$ExcludeVMs
)

Write-Output "[TechLogic-Orchestrator] Execution Started: $(Get-Date)"

try {
    Connect-AzAccount -Identity
    Write-Output "[TechLogic-Orchestrator] Authenticated using Managed Identity."
}
catch {
    throw "[TechLogic-Orchestrator] Authentication failed."
}

# Retrieve VMs
if ($VMName) {
    $VMs = Get-AzVM -Name $VMName -ResourceGroupName $ResourceGroupName
}
elseif ($ResourceGroupName) {
    $VMs = Get-AzVM -ResourceGroupName $ResourceGroupName
}
else {
    $VMs = Get-AzVM
}

# Tag filtering
if ($TagName -and $TagValue) {
    $VMs = $VMs | Where-Object {
        $_.Tags[$TagName] -eq $TagValue
    }
}

# Exclusion filtering
if ($ExcludeVMs) {
    $VMs = $VMs | Where-Object {
        $ExcludeVMs -notcontains $_.Name
    }
}

foreach ($VM in $VMs) {
    try {
        if ($Action -eq "Start") {
            Start-AzVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName -NoWait
            Write-Output "[TechLogic-Orchestrator] Starting VM: $($VM.Name)"
        }
        elseif ($Action -eq "Stop") {
            Stop-AzVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName -Force -NoWait
            Write-Output "[TechLogic-Orchestrator] Stopping VM: $($VM.Name)"
        }
    }
    catch {
        Write-Error "[TechLogic-Orchestrator] Failed action on VM: $($VM.Name)"
    }
}

Write-Output "[TechLogic-Orchestrator] Execution Completed: $(Get-Date)"
