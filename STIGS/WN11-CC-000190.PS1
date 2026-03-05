<#
.SYNOPSIS
    This PowerShell script ensures that Autoplay is disabled for all drives on Windows 11.

.NOTES
    Author          : Justin Flip
    LinkedIn        : linkedin.com/in/justinflip/
    GitHub          : github.com/JustinFlip
    Date Created    : 2026-03-04
    Last Modified   : 2026-03-04
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000190

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Disables Autoplay for all drives on Windows 11.
    Run with Administrator privileges.
    
    Example syntax:
    PS C:\> .\Remediation-WN11-CC-000190-DisableAutoplay.ps1
#>

# Verify Administrator privileges
$isAdmin = ([Security.Principal.WindowsIdentity]::GetCurrent()).Groups -contains 'S-1-5-32-544'
if (-not $isAdmin) {
    Write-Host "ERROR: This script requires Administrator privileges!" -ForegroundColor Red
    exit 1
}

Write-Host "Remediating STIG WN11-CC-000190: Disable Autoplay for All Drives" -ForegroundColor Cyan
Write-Host "Disabling Autoplay..." -ForegroundColor Yellow

try {
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    
    if (-not (Test-Path $registryPath)) {
        Write-Host "Creating registry path: $registryPath" -ForegroundColor Gray
        New-Item -Path $registryPath -Force -ErrorAction Stop | Out-Null
        Write-Host "✓ Created registry path" -ForegroundColor Green
    }
    
    Set-ItemProperty -Path $registryPath -Name "NoDriveTypeAutoRun" -Value 255 -Type DWORD -Force -ErrorAction Stop
    Write-Host "✓ Autoplay registry value NoDriveTypeAutoRun set to 255" -ForegroundColor Green
    
    $verifyValue = Get-ItemProperty -Path $registryPath -Name "NoDriveTypeAutoRun" -ErrorAction SilentlyContinue
    if ($verifyValue.NoDriveTypeAutoRun -eq 255) {
        Write-Host "✓ Autoplay successfully disabled for all drives" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000190 remediated successfully" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "⚠ Registry setting may not have been applied correctly" -ForegroundColor Yellow
        exit 0
    }
}
catch {
    Write-Host "✗ Error remediating STIG WN11-CC-000190: $_" -ForegroundColor Red
    exit 1
}
