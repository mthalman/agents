#Requires -Version 5.1

<#
.SYNOPSIS
    Template Generator - Quickly create new customization files
.DESCRIPTION
    This script generates new customization files from templates.
.PARAMETER Type
    Type of customization to create. Valid values depend on the Tool:
    - For Claude: agents, commands, output-styles
    - For Copilot: modes, prompts
.PARAMETER Name
    Name for the new customization
.PARAMETER Tool
    Target tool (claude or copilot)
.PARAMETER Common
    Create in common directory (shared across tools)
.EXAMPLE
    .\new.ps1 -Type agents -Name my-code-reviewer -Tool claude
    Create a Claude-specific agent
.EXAMPLE
    .\new.ps1 -Type agents -Name security-reviewer -Common
    Create a common agent (works with both Claude and Copilot)
.EXAMPLE
    .\new.ps1 -Type prompts -Name git-commit-message -Tool copilot
    Create a new Copilot prompt template
#>

[CmdletBinding(DefaultParameterSetName='ToolSpecific')]
param(
    [Parameter(Mandatory=$true)]
    [string]$Type,
    
    [Parameter(Mandatory=$true)]
    [string]$Name,
    
    [Parameter(Mandatory=$true, ParameterSetName='ToolSpecific')]
    [ValidateSet('claude', 'copilot')]
    [string]$Tool,
    
    [Parameter(Mandatory=$true, ParameterSetName='CommonShared')]
    [switch]$Common
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path $ScriptDir -Parent

# Import common functions
. (Join-Path $ScriptDir 'common.ps1')

# Validate Type parameter based on Tool
$targetDir = if ($Common) { 'common' } else { $Tool }
$validTypes = Get-ValidTypes -Tool $(if ($Common) { 'claude' } else { $Tool }) -RepoRoot $RepoRoot

# For common, we support all types from both tools
if ($Common) {
    $claudeTypes = Get-ValidTypes -Tool 'claude' -RepoRoot $RepoRoot
    $copilotTypes = Get-ValidTypes -Tool 'copilot' -RepoRoot $RepoRoot
    $validTypes = $claudeTypes + $copilotTypes | Select-Object -Unique
}

if ($validTypes -notcontains $Type) {
    Write-Error "Invalid Type '$Type' for target '$targetDir'. Valid types: $($validTypes -join ', ')"
    exit 1
}

# Load and process template
function New-FromTemplate {
    param(
        [string]$CustomizationName,
        [string]$CustomizationType,
        [string]$TargetDirectory
    )
    
    # Determine paths
    $typeDir = Join-Path $RepoRoot "$TargetDirectory\$CustomizationType"
    $templatePath = Join-Path $typeDir '.template.md'
    $outputPath = Join-Path $typeDir "$CustomizationName.md"
    
    # Check if template exists
    if (-not (Test-Path $templatePath)) {
        Write-Error "Template not found: $templatePath"
        Write-Info "Please create a .template.md file in the $CustomizationType directory"
        exit 1
    }
    
    # Check if output file already exists
    if (Test-Path $outputPath) {
        Write-Info "File already exists: $outputPath"
        $response = Read-Host "Overwrite? [y/N]"
        if ($response -ne 'y' -and $response -ne 'Y') {
            return
        }
    }
    
    # Ensure directory exists
    if (-not (Test-Path $typeDir)) {
        New-Item -ItemType Directory -Path $typeDir -Force | Out-Null
    }
    
    # Read template content
    $templateContent = Get-Content -Path $templatePath -Raw -Encoding UTF8
    
    # Prepare replacements
    $date = Get-Date -Format 'yyyy-MM-dd'
    $replacements = @{
        'NAME' = $CustomizationName
        'DATE' = $date
    }
    
    # Process template
    $content = Resolve-TemplatePlaceholders -Content $templateContent -Replacements $replacements
    
    # Write output file
    $content | Out-File -FilePath $outputPath -Encoding UTF8
    
    # Success message
    $targetInfo = if ($TargetDirectory -eq 'common') { 'common (shared)' } else { "$TargetDirectory-specific" }
    Write-Success "Created $targetInfo $CustomizationType customization: $outputPath"
    Write-Info "Edit the file to customize your $CustomizationType"
}

# Main
New-FromTemplate -CustomizationName $Name -CustomizationType $Type -TargetDirectory $targetDir


