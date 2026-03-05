<#
.SYNOPSIS
    This PowerShell script ensures that the Secondary Logon service is disabled on Windows 11.

.NOTES
    Author          : Justin Flip
    LinkedIn        : linkedin.com/in/justinflip/
    GitHub          : github.com/JustinFlip
    Date Created    : 2026-03-04
    Last Modified   : 2026-03-04
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000175

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Disables the Secondary Logon (RunAs) service on Windows 11.
    Run with Administrator privileges.
    
    Example syntax:
    PS C:\> .\Remediation-WN11-00-000175-DisableSecondaryLogon.ps1
#>

# Verify Administrator privileges
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent()).Groups -contains 'S-1-5-32-544'
if (-not $isAdmin) {
    Write-Host "ERROR: This script requires Administrator privileges!" -ForegroundColor Red
    exit 1
}

Write-Host "Remediating STIG WN11-00-000175: Disable Secondary Logon Service" -ForegroundColor Cyan
Write-Host "Disabling Secondary Logon (seclogon) service..." -ForegroundColor Yellow

try {
    $secLogonService = Get-Service -Name "seclogon" -ErrorAction SilentlyContinue
    
    if ($null -eq $secLogonService) {
        Write-Host "✗ Secondary Logon service not found on this system" -ForegroundColor Red
        exit 1
    }
    
    Set-Service -Name "seclogon" -StartupType Disabled -ErrorAction Stop
    Write-Host "✓ Secondary Logon service set to Disabled startup type" -ForegroundColor Green
    
    if ($secLogonService.Status -eq "Running") {
        Stop-Service -Name "seclogon" -Force -ErrorAction Stop
        Write-Host "✓ Secondary Logon service stopped" -ForegroundColor Green
    } else {
        Write-Host "ℹ Secondary Logon service is not currently running" -ForegroundColor Yellow
    }
    
    $verifyService = Get-Service -Name "seclogon"
    if ($verifyService.StartType -eq "Disabled") {
        Write-Host "✓ Secondary Logon service startup type verified as Disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-00-000175 remediated successfully" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "⚠ Service startup type may not have changed as expected" -ForegroundColor Yellow
        exit 0
    }
}
catch {
    Write-Host "✗ Error remediating STIG WN11-00-000175: $_" -ForegroundColor Red
    exit 1
}
