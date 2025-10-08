#Requires -Version 5.1

<#
.SYNOPSIS
    Transform unified agent format to Claude Code CLI format
.DESCRIPTION
    Converts agents from the repository's unified format to Claude Code CLI specific format.
    Supports both unified agents (root level) and Claude-specific agents (claude/ subdirectory).
.PARAMETER SourceDir
    Source directory containing agent definitions
.PARAMETER TargetDir
    Target directory for Claude Code CLI configuration
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

function Transform-AgentForClaude {
    param(
        [string]$SourceFile,
        [string]$TargetFile
    )
    
    # For Claude Code CLI, the format with YAML frontmatter works directly
    # Copy the file as-is (assumes it uses the correct format)
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

# Process unified agents (files in root of agents/ directory)
Write-Info "Processing unified agents..."
$unifiedAgents = Get-ChildItem -Path $SourceDir -Filter *.md -File | Where-Object { $_.Name -ne 'README.md' }

foreach ($file in $unifiedAgents) {
    $targetFile = Join-Path $agentsTargetDir $file.Name
    Transform-AgentForClaude -SourceFile $file.FullName -TargetFile $targetFile
}

# Process Claude-specific agents (files in agents/claude/ subdirectory)
$claudeSpecificDir = Join-Path $SourceDir 'claude'
if (Test-Path $claudeSpecificDir) {
    Write-Info "Processing Claude-specific agents..."
    $claudeAgents = Get-ChildItem -Path $claudeSpecificDir -Filter *.md -Recurse | Where-Object { $_.Name -ne 'README.md' }
    
    foreach ($file in $claudeAgents) {
        $relativePath = $file.FullName.Substring($claudeSpecificDir.Length + 1)
        $targetFile = Join-Path $agentsTargetDir $relativePath
        Transform-AgentForClaude -SourceFile $file.FullName -TargetFile $targetFile
    }
}

if (-not $DryRun) {
    Write-Success "Claude Code CLI agent transformation complete"
}
