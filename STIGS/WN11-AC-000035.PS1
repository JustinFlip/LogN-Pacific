<#
.SYNOPSIS
    This PowerShell script ensures that the minimum password length is configured to at least 14 characters.

.NOTES
    Author          : Justin Flip
    LinkedIn        : linkedin.com/in/justinflip/
    GitHub          : github.com/JustinFlip
    Date Created    : 2026-03-04
    Last Modified   : 2026-03-04
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000035

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Configures the minimum password length to 14 characters to meet the STIG requirement.
    Run with Administrator privileges.
    
    Example syntax:
    PS C:\> .\Remediation-WN11-AC-000035-MinPasswordLength.ps1
#>

# Verify Administrator privileges
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent()).Groups -contains 'S-1-5-32-544'
if (-not $isAdmin) {
    Write-Host "ERROR: This script requires Administrator privileges!" -ForegroundColor Red
    exit 1
}

Write-Host "Remediating STIG WN11-AC-000035: Minimum Password Length" -ForegroundColor Cyan
Write-Host "Setting minimum password length to 14 characters..." -ForegroundColor Yellow

try {
    net accounts /minpwlen:14 | Out-Null
    
    $accountInfo = net accounts
    if ($accountInfo -match "Minimum password length.*14") {
        Write-Host "✓ Minimum password length successfully set to 14 characters" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000035 remediated successfully" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "⚠ Setting applied but verification returned unexpected result" -ForegroundColor Yellow
        Write-Host $accountInfo
        exit 0
    }
}
catch {
    Write-Host "✗ Error remediating STIG WN11-AC-000035: $_" -ForegroundColor Red
    exit 1
}
