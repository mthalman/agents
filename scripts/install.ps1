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
.PARAMETER Component
    Specific components to install (all, agents, prompts, mcp, tools, modes)
.EXAMPLE
    .\install.ps1 -DryRun
    Preview what would be installed
.EXAMPLE
    .\install.ps1 -Component agents,prompts
    Install only agents and prompts
.EXAMPLE
    .\install.ps1 -Backup -Force
    Install all components with backup and force overwrite
#>

[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Force,
    [switch]$Backup,
    [ValidateSet('all', 'agents', 'prompts', 'mcp', 'tools', 'modes')]
    [string[]]$Component = @('all')
)

$ErrorActionPreference = 'Stop'

# Get repository root
$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path $ScriptDir -Parent

# Get home directory (cross-platform)
$HomeDir = if ($env:USERPROFILE) { $env:USERPROFILE } else { $env:HOME }

# Default installation paths
$ClaudeConfigDir = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $HomeDir '.claude' }
$CopilotConfigDir = if ($env:COPILOT_CONFIG_DIR) { $env:COPILOT_CONFIG_DIR } elseif ($env:APPDATA) { Join-Path $env:APPDATA 'GitHub Copilot' } else { Join-Path $HomeDir '.config/github-copilot' }
$MCPConfigDir = if ($env:MCP_CONFIG_DIR) { $env:MCP_CONFIG_DIR } else { Join-Path $HomeDir '.config/mcp' }
$ToolsDir = if ($env:TOOLS_DIR) { $env:TOOLS_DIR } elseif ($env:LOCALAPPDATA) { Join-Path $env:LOCALAPPDATA 'ai-tools' } else { Join-Path $HomeDir '.local/share/ai-tools' }
$ModesDir = if ($env:MODES_DIR) { $env:MODES_DIR } else { Join-Path $HomeDir '.config/ai-modes' }

# Logging functions
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Create a backup of a file
function Backup-File {
    param([string]$FilePath)
    
    if (Test-Path $FilePath) {
        $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
        $backupPath = "$FilePath.backup.$timestamp"
        
        if ($DryRun) {
            Write-Info "Would backup: $FilePath -> $backupPath"
        } else {
            Copy-Item -Path $FilePath -Destination $backupPath -Force
            Write-Success "Created backup: $backupPath"
        }
    }
}

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
    $files = Get-ChildItem -Path $Source -File -Recurse | Where-Object { $_.Name -ne 'README.md' }
    if ($files.Count -eq 0) {
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
                Backup-File $destFile
            }
        }
        
        # Copy file
        if ($DryRun) {
            Write-Info "Would install: $relativePath -> $destFile"
        } else {
            Copy-Item -Path $file.FullName -Destination $destFile -Force
            if ($VerbosePreference -eq 'Continue') {
                Write-Success "Installed: $relativePath"
            }
        }
    }
    
    Write-Success "Finished installing $Description"
}

# Transform and install agents
function Install-Agents {
    Write-Info "=== Installing Agent Configurations ==="
    
    # Source agents (unified format)
    $sourceDir = Join-Path $RepoRoot 'agents'
    
    # Transform and install for Claude
    $transformScript = Join-Path $ScriptDir 'transform-for-claude.ps1'
    if (Test-Path $transformScript) {
        Write-Info "Transforming agents for Claude Code CLI..."
        & $transformScript -SourceDir $sourceDir -TargetDir $ClaudeConfigDir -DryRun:$DryRun -Verbose:($VerbosePreference -eq 'Continue')
    } else {
        # Fallback: direct copy
        $claudeAgentsDir = Join-Path $ClaudeConfigDir 'agents'
        Install-Files -Source $sourceDir -Destination $claudeAgentsDir -Description 'Claude agents'
    }
    
    # Transform and install for Copilot
    $transformScript = Join-Path $ScriptDir 'transform-for-copilot.ps1'
    if (Test-Path $transformScript) {
        Write-Info "Transforming agents for GitHub Copilot..."
        & $transformScript -SourceDir $sourceDir -TargetDir $CopilotConfigDir -DryRun:$DryRun -Verbose:($VerbosePreference -eq 'Continue')
    } else {
        # Fallback: direct copy
        $copilotAgentsDir = Join-Path $CopilotConfigDir 'agents'
        Install-Files -Source $sourceDir -Destination $copilotAgentsDir -Description 'Copilot agents'
    }
}

# Install prompts
function Install-Prompts {
    Write-Info "=== Installing Prompts ==="
    $promptsSourceDir = Join-Path $RepoRoot 'prompts'
    $destDir = Join-Path $HomeDir '.config/ai-prompts'
    Install-Files -Source $promptsSourceDir -Destination $destDir -Description 'prompts'
}

# Install MCP configurations
function Install-MCP {
    Write-Info "=== Installing MCP Configurations ==="
    
    $mcpSourceDir = Join-Path $RepoRoot 'mcp'
    
    # MCP servers
    $serversDir = Join-Path $mcpSourceDir 'servers'
    if (Test-Path $serversDir) {
        $destDir = Join-Path $MCPConfigDir 'servers'
        Install-Files -Source $serversDir -Destination $destDir -Description 'MCP servers'
    }
    
    # MCP clients
    $clientsDir = Join-Path $mcpSourceDir 'clients'
    if (Test-Path $clientsDir) {
        $destDir = Join-Path $MCPConfigDir 'clients'
        Install-Files -Source $clientsDir -Destination $destDir -Description 'MCP clients'
    }
    
    # Custom MCP
    $customDir = Join-Path $mcpSourceDir 'custom'
    if (Test-Path $customDir) {
        $destDir = Join-Path $MCPConfigDir 'custom'
        Install-Files -Source $customDir -Destination $destDir -Description 'Custom MCP'
    }
}

# Install tools
function Install-Tools {
    Write-Info "=== Installing Tools ==="
    
    $toolsSourceDir = Join-Path $RepoRoot 'tools'
    
    # Scripts
    $scriptsDir = Join-Path $toolsSourceDir 'scripts'
    if (Test-Path $scriptsDir) {
        $destDir = Join-Path $ToolsDir 'scripts'
        Install-Files -Source $scriptsDir -Destination $destDir -Description 'tool scripts'
    }
    
    # Plugins
    $pluginsDir = Join-Path $toolsSourceDir 'plugins'
    if (Test-Path $pluginsDir) {
        $destDir = Join-Path $ToolsDir 'plugins'
        Install-Files -Source $pluginsDir -Destination $destDir -Description 'tool plugins'
    }
    
    # Integrations
    $integrationsDir = Join-Path $toolsSourceDir 'integrations'
    if (Test-Path $integrationsDir) {
        $destDir = Join-Path $ToolsDir 'integrations'
        Install-Files -Source $integrationsDir -Destination $destDir -Description 'integrations'
    }
}

# Install modes
function Install-Modes {
    Write-Info "=== Installing Modes ==="
    $modesSourceDir = Join-Path $RepoRoot 'modes'
    Install-Files -Source $modesSourceDir -Destination $ModesDir -Description 'modes'
}

# Main installation logic
function Main {
    Write-Info "AI Agent Customizations Installation"
    Write-Info "Repository: $RepoRoot"
    
    if ($DryRun) {
        Write-Warning "DRY RUN MODE - No changes will be made"
    }
    
    Write-Host ""
    
    # Process components
    foreach ($comp in $Component) {
        switch ($comp) {
            'all' {
                Install-Agents
                Install-Prompts
                Install-MCP
                Install-Tools
                Install-Modes
            }
            'agents' { Install-Agents }
            'prompts' { Install-Prompts }
            'mcp' { Install-MCP }
            'tools' { Install-Tools }
            'modes' { Install-Modes }
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
