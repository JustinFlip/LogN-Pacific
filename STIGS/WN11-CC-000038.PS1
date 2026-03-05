<#
.SYNOPSIS
    This PowerShell script ensures that WDigest Authentication is disabled on Windows 11.

.NOTES
    Author          : Justin Flip
    LinkedIn        : linkedin.com/in/justinflip/
    GitHub          : github.com/JustinFlip
    Date Created    : 2026-03-04
    Last Modified   : 2026-03-04
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000038

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Disables WDigest authentication on Windows 11.
    Run with Administrator privileges.
    
    Example syntax:
    PS C:\> .\Remediation-WN11-CC-000038-DisableWDigest.ps1
#>

# Verify Administrator privileges
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent()).Groups -contains 'S-1-5-32-544'
if (-not $isAdmin) {
    Write-Host "ERROR: This script requires Administrator privileges!" -ForegroundColor Red
    exit 1
}

Write-Host "Remediating STIG WN11-CC-000038: Disable WDigest Authentication" -ForegroundColor Cyan
Write-Host "Disabling WDigest authentication..." -ForegroundColor Yellow

try {
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest"
    
    if (-not (Test-Path $registryPath)) {
        Write-Host "Creating registry path: $registryPath" -ForegroundColor Gray
        New-Item -Path $registryPath -Force -ErrorAction Stop | Out-Null
        Write-Host "✓ Created registry path" -ForegroundColor Green
    }
    
    Set-ItemProperty -Path $registryPath -Name "UseLogonCredential" -Value 0 -Type DWORD -Force -ErrorAction Stop
    Write-Host "✓ WDigest UseLogonCredential registry value set to 0" -ForegroundColor Green
    
    $verifyValue = Get-ItemProperty -Path $registryPath -Name "UseLogonCredential" -ErrorAction SilentlyContinue
    if ($verifyValue.UseLogonCredential -eq 0) {
        Write-Host "✓ WDigest authentication successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000038 remediated successfully" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "⚠ Registry setting may not have been applied correctly" -ForegroundColor Yellow
        exit 0
    }
}
catch {
    Write-Host "✗ Error remediating STIG WN11-CC-000038: $_" -ForegroundColor Red
    exit 1
}
