#Requires -Version 5.1

<#
.SYNOPSIS
    Run tests for the AI Agent Installation Scripts
.DESCRIPTION
    This script runs the Pester test suite for the installation scripts.
    It will install Pester if not already present.
.PARAMETER TestPath
    Path to specific test file(s) to run
.PARAMETER OutputFormat
    Output format for test results (NUnitXml, JUnitXml, or None)
.PARAMETER PassThru
    Return the Pester result object
.PARAMETER Show
    What to show in output (All, Fails, None, etc.)
.EXAMPLE
    .\run-tests.ps1
    Run all tests with default output
.EXAMPLE
    .\run-tests.ps1 -TestPath .\install.tests.ps1 -Show Fails
    Run specific tests and only show failures
#>

[CmdletBinding()]
param(
    [string]$TestPath = (Join-Path $PSScriptRoot '*.tests.ps1'),
    [ValidateSet('NUnitXml', 'JUnitXml', 'None')]
    [string]$OutputFormat = 'None',
    [switch]$PassThru,
    [ValidateSet('None', 'Normal', 'Detailed', 'Diagnostic')]
    [string]$Show = 'Normal'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [ConsoleColor]$Color = 'White'
    )
    Write-Host $Message -ForegroundColor $Color
}

# Check if Pester is installed
Write-ColorOutput "Checking for Pester module..." -Color Cyan

$pesterModule = Get-Module -ListAvailable -Name Pester | Where-Object { $_.Version -ge [version]'5.0.0' }

if (-not $pesterModule) {
    Write-ColorOutput "Pester 5.0+ not found. Installing Pester..." -Color Yellow

    # Check if running as administrator
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if ($isAdmin) {
        Install-Module -Name Pester -MinimumVersion 5.0.0 -Force -SkipPublisherCheck
    } else {
        Install-Module -Name Pester -MinimumVersion 5.0.0 -Force -SkipPublisherCheck -Scope CurrentUser
    }

    Write-ColorOutput "Pester installed successfully." -Color Green

    # Import the newly installed module
    Import-Module Pester -MinimumVersion 5.0.0 -Force
} else {
    Write-ColorOutput "Pester $($pesterModule.Version) found." -Color Green
    Import-Module Pester -MinimumVersion 5.0.0 -Force
}

# Configure Pester
$pesterConfiguration = New-PesterConfiguration

# Set test path
$pesterConfiguration.Run.Path = $TestPath
$pesterConfiguration.Run.PassThru = $true

# Configure output
$pesterConfiguration.Output.Verbosity = $Show

# Configure test result output
if ($OutputFormat -ne 'None') {
    $outputFile = Join-Path $PSScriptRoot "TestResults_$(Get-Date -Format 'yyyyMMdd_HHmmss').xml"

    if ($OutputFormat -eq 'NUnitXml') {
        $pesterConfiguration.TestResult.Enabled = $true
        $pesterConfiguration.TestResult.OutputFormat = 'NUnitXml'
        $pesterConfiguration.TestResult.OutputPath = $outputFile
    } elseif ($OutputFormat -eq 'JUnitXml') {
        $pesterConfiguration.TestResult.Enabled = $true
        $pesterConfiguration.TestResult.OutputFormat = 'JUnitXml'
        $pesterConfiguration.TestResult.OutputPath = $outputFile
    }
}

# Run tests
Write-ColorOutput "`nRunning tests..." -Color Cyan
Write-ColorOutput "Test Path: $TestPath" -Color Gray
Write-ColorOutput "=" * 70 -Color DarkGray

$testResult = Invoke-Pester -Configuration $pesterConfiguration

# Display summary
Write-ColorOutput "`n" -Color White
Write-ColorOutput "=" * 70 -Color DarkGray
Write-ColorOutput "TEST RESULTS SUMMARY" -Color Cyan
Write-ColorOutput "=" * 70 -Color DarkGray

if ($testResult.FailedCount -eq 0) {
    Write-ColorOutput "✅ ALL TESTS PASSED!" -Color Green
} else {
    Write-ColorOutput "❌ SOME TESTS FAILED" -Color Red
}

Write-ColorOutput "`nTotal Tests:  $($testResult.TotalCount)" -Color White
Write-ColorOutput "Passed:       $($testResult.PassedCount)" -Color Green
Write-ColorOutput "Failed:       $($testResult.FailedCount)" -Color $(if ($testResult.FailedCount -gt 0) { 'Red' } else { 'Gray' })
Write-ColorOutput "Skipped:      $($testResult.SkippedCount)" -Color Yellow
Write-ColorOutput "Duration:     $($testResult.Duration.TotalSeconds.ToString('0.00')) seconds" -Color Gray

if ($OutputFormat -ne 'None' -and $outputFile) {
    Write-ColorOutput "`nTest results saved to: $outputFile" -Color Cyan
}

# Return result object if requested
if ($PassThru) {
    return $testResult
}

# Exit with appropriate code for CI/CD
exit $testResult.FailedCount