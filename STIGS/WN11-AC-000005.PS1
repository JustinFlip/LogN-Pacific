<#
.SYNOPSIS
    This PowerShell script ensures that the Windows account lockout duration is configured to 15 minutes or greater.

.NOTES
    Author          : Justin Flip
    LinkedIn        : linkedin.com/in/justinflip/
    GitHub          : https://github.com/JustinFlip
    Date Created    : 03-04-2026
    Last Modified   : 03-04-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000005

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Configures the account lockout duration to 30 minutes to meet the minimum STIG requirement of 15 minutes or greater.
    Run with Administrator privileges.
    
    Example syntax:
    PS C:\> .\Remediation-WN11-AC-000005-AccountLockoutDuration.ps1
#>

# Verify Administrator privileges
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent()).Groups -contains 'S-1-5-32-544'
if (-not $isAdmin) {
    Write-Host "ERROR: This script requires Administrator privileges!" -ForegroundColor Red
    exit 1
}

Write-Host "Remediating STIG WN11-AC-000005: Account Lockout Duration" -ForegroundColor Cyan
Write-Host "Setting account lockout duration to 30 minutes..." -ForegroundColor Yellow

try {
    net accounts /lockoutduration:30 | Out-Null
    
    $accountInfo = net accounts
    if ($accountInfo -match "Lockout duration.*30 minutes") {
        Write-Host "✓ Account lockout duration successfully set to 30 minutes" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000005 remediated successfully" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "⚠ Setting applied but verification returned unexpected result" -ForegroundColor Yellow
        Write-Host $accountInfo
        exit 0
    }
}
catch {
    Write-Host "✗ Error remediating STIG WN11-AC-000005: $_" -ForegroundColor Red
    exit 1
}
