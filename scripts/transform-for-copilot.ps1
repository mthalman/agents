#Requires -Version 5.1

<#
.SYNOPSIS
    Transform unified agent format to GitHub Copilot format
.DESCRIPTION
    Converts agents from the repository's unified format to GitHub Copilot specific format
.PARAMETER SourceDir
    Source directory containing unified agent definitions
.PARAMETER TargetDir
    Target directory for GitHub Copilot configuration
.PARAMETER DryRun
    Preview transformation without making changes
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$SourceDir,
    
    [Parameter(Mandatory=$true)]
    [string]$TargetDir,
    
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Transform-AgentForCopilot {
    param(
        [string]$SourceFile,
        [string]$TargetFile
    )
    
    # For GitHub Copilot, the unified markdown format works directly
    # Just copy the file as-is
    if ($DryRun) {
        Write-Info "Would transform: $SourceFile -> $TargetFile"
    } else {
        $targetDir = Split-Path $TargetFile -Parent
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
        Copy-Item -Path $SourceFile -Destination $TargetFile -Force
        Write-Success "Transformed: $(Split-Path $SourceFile -Leaf)"
    }
}

# Main transformation logic
$agentsTargetDir = Join-Path $TargetDir 'agents'

if (-not (Test-Path $SourceDir)) {
    Write-Info "Source directory not found: $SourceDir"
    return
}

# Get all agent files (excluding README)
$agentFiles = Get-ChildItem -Path $SourceDir -Filter *.md -Recurse | Where-Object { $_.Name -ne 'README.md' }

foreach ($file in $agentFiles) {
    $relativePath = $file.FullName.Substring($SourceDir.Length + 1)
    $targetFile = Join-Path $agentsTargetDir $relativePath
    Transform-AgentForCopilot -SourceFile $file.FullName -TargetFile $targetFile
}

if (-not $DryRun) {
    Write-Success "GitHub Copilot agent transformation complete"
}
