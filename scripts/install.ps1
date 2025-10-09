#Requires -Version 5.1

<#
.SYNOPSIS
    AI Agent Customizations Installation Script
.DESCRIPTION
    This script helps deploy customizations from this repository to your system.
.PARAMETER DryRun
    Show what would be installed without making changes
.PARAMETER Force
    Overwrite existing files
.PARAMETER Backup
    Create backups of existing files before overwriting
.PARAMETER Verbose
    Enable verbose output
.PARAMETER Tool
    Specific tools to install (all, claude, copilot)
.EXAMPLE
    .\install.ps1 -DryRun
    Preview what would be installed
.EXAMPLE
    .\install.ps1 -Backup -Force
    Install all tools with backup and force overwrite
.EXAMPLE
    .\install.ps1 -Tool claude
    Install only Claude customizations
.EXAMPLE
    .\install.ps1 -Tool common
    Install common content to both Claude and Copilot
#>

[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Force,
    [switch]$Backup,
    [ValidateSet('all', 'claude', 'copilot')]
    [string[]]$Tool = @('all')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Get repository root
$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path $ScriptDir -Parent

# Import common functions
. (Join-Path $ScriptDir 'common.ps1')

# Get configuration directories
$ConfigDirs = Get-ConfigDirectories

$ClaudeConfigDir = $ConfigDirs.Claude.Root
$ClaudeAgentsDir = Join-Path $ClaudeConfigDir 'agents'
$ClaudeCommandsDir = Join-Path $ClaudeConfigDir 'commands'
$ClaudeOutputStylesDir = Join-Path $ClaudeConfigDir 'output-styles'

$CopilotConfigDir = $ConfigDirs.Copilot.Root
$CopilotPromptsDir = Join-Path $CopilotConfigDir 'prompts'
$CopilotModesDir = Join-Path $CopilotConfigDir 'modes'

# Copy files from source to destination
function Install-Files {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Description
    )
    
    Write-Info "Installing $Description..."
    
    # Create destination directory
    if ($DryRun) {
        Write-Info "Would create directory: $Destination"
    } else {
        if (-not (Test-Path $Destination)) {
            New-Item -ItemType Directory -Path $Destination -Force | Out-Null
            if ($VerbosePreference -eq 'Continue') {
                Write-Info "Created directory: $Destination"
            }
        }
    }
    
    # Check if source directory exists and has files
    if (-not (Test-Path $Source)) {
        Write-Warning "Source directory not found: $Source"
        return
    }
    
    # Count files to install
    $files = Get-ChildItem -Path $Source -File -Recurse | Where-Object { 
        $_.Name -ne 'README.md' -and $_.Name -ne '.template.md' 
    }
    if (-not $files -or @($files).Count -eq 0) {
        Write-Warning "No files to install in $Source"
        return
    }
    
    # Copy files
    foreach ($file in $files) {
        $relativePath = $file.FullName.Substring($Source.Length + 1)
        $destFile = Join-Path $Destination $relativePath
        $destDir = Split-Path $destFile -Parent
        
        # Create subdirectories
        if ($DryRun) {
            if ($VerbosePreference -eq 'Continue') {
                Write-Info "Would create: $destDir"
            }
        } else {
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }
        }
        
        # Handle existing files
        if (Test-Path $destFile) {
            if (-not $Force) {
                Write-Warning "File exists (use -Force to overwrite): $destFile"
                continue
            }
            
            if ($Backup) {
                Backup-File -FilePath $destFile -DryRun:$DryRun
            }
        }
        
        # Copy file (with include processing for text files)
        if ($DryRun) {
            Write-Info "Would install: $relativePath -> $destFile"
        } else {
            $extension = [System.IO.Path]::GetExtension($file.FullName).ToLower()
            if ($extension -in @('.md', '.txt', '.json', '.yaml', '.yml')) {
                # Process includes for text files
                $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
                $processedContent = Resolve-Includes -Content $content -RepoRoot $RepoRoot
                $processedContent | Out-File -FilePath $destFile -Encoding UTF8 -NoNewline
            } else {
                # Binary copy for other files
                Copy-Item -Path $file.FullName -Destination $destFile -Force
            }
            
            if ($VerbosePreference -eq 'Continue') {
                Write-Success "Installed: $relativePath"
            }
        }
    }
    
    Write-Success "Finished installing $Description"
}

# Install Claude-specific customizations
function Install-Claude {
    Write-Info "=== Installing Claude Customizations ==="
    
    # Claude agents
    $sourceAgentsDir = Join-Path $RepoRoot 'claude/agents'
    if (Test-Path $sourceAgentsDir) {
        Install-Files -Source $sourceAgentsDir -Destination $ClaudeAgentsDir -Description 'Claude agents'
    }

    # Claude commands
    $sourceCommandsDir = Join-Path $RepoRoot 'claude/commands'
    if (Test-Path $sourceCommandsDir) {
        Install-Files -Source $sourceCommandsDir -Destination $ClaudeCommandsDir -Description 'Claude commands'
    }

    # Claude output styles
    $sourceOutputStylesDir = Join-Path $RepoRoot 'claude/output-styles'
    if (Test-Path $sourceOutputStylesDir) {
        Install-Files -Source $sourceOutputStylesDir -Destination $ClaudeOutputStylesDir -Description 'Claude output styles'
    }
}

# Install Copilot-specific customizations
function Install-Copilot {
    Write-Info "=== Installing Copilot Customizations ==="
    
    # Copilot modes
    $sourceModesDir = Join-Path $RepoRoot 'copilot/modes'
    if (Test-Path $sourceModesDir) {
        Install-Files -Source $sourceModesDir -Destination $CopilotModesDir -Description 'Copilot modes'
    }
    
    # Copilot prompts
    $sourcePromptsDir = Join-Path $RepoRoot 'copilot/prompts'
    if (Test-Path $sourcePromptsDir) {
        Install-Files -Source $sourcePromptsDir -Destination $CopilotPromptsDir -Description 'Copilot prompts'
    }
}

# Main installation logic
function Main {
    Write-Info "AI Agent Customizations Installation"
    Write-Info "Repository: $RepoRoot"
    
    if ($DryRun) {
        Write-Warning "DRY RUN MODE - No changes will be made"
    }
    
    Write-Host ""
    
    # Process tools
    foreach ($t in $Tool) {
        switch ($t) {
            'all' {
                Install-Claude
                Install-Copilot
            }
            'claude' { 
                Install-Claude 
            }
            'copilot' { 
                Install-Copilot 
            }
        }
        Write-Host ""
    }
    
    if ($DryRun) {
        Write-Info "Dry run complete. Run without -DryRun to apply changes."
    } else {
        Write-Success "Installation complete!"
        Write-Info "You may need to restart your AI tools to pick up the new configurations."
    }
}

# Run main
Main
