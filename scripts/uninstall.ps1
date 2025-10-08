#Requires -Version 5.1

<#
.SYNOPSIS
    AI Agent Customizations Uninstall Script
.DESCRIPTION
    This script helps remove deployed customizations from your system.
.PARAMETER DryRun
    Show what would be removed without making changes
.PARAMETER Force
    Remove without confirmation
.PARAMETER Component
    Specific components to remove (all, agents, prompts, mcp, tools, modes)
.EXAMPLE
    .\uninstall.ps1 -DryRun
    Preview what would be removed
.EXAMPLE
    .\uninstall.ps1 -Component mcp
    Remove only MCP configurations
.EXAMPLE
    .\uninstall.ps1 -Force
    Remove all components without confirmation
#>

[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Force,
    [ValidateSet('all', 'agents', 'prompts', 'mcp', 'tools', 'modes')]
    [string[]]$Component = @('all')
)

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

# Remove directory with confirmation
function Remove-Directory {
    param(
        [string]$Path,
        [string]$Description
    )
    
    if (-not (Test-Path $Path)) {
        if ($VerbosePreference -eq 'Continue') {
            Write-Info "Directory does not exist: $Path"
        }
        return
    }
    
    if ($DryRun) {
        Write-Info "Would remove: $Path ($Description)"
    } else {
        if (-not $Force) {
            $response = Read-Host "Remove $Description at $Path? [y/N]"
            if ($response -ne 'y' -and $response -ne 'Y') {
                Write-Info "Skipped: $Description"
                return
            }
        }
        
        Remove-Item -Path $Path -Recurse -Force
        Write-Success "Removed: $Description"
    }
}

# Uninstall agents
function Uninstall-Agents {
    Write-Info "=== Removing Agent Configurations ==="
    Remove-Directory -Path (Join-Path $ClaudeConfigDir 'agents') -Description 'Claude agents'
    Remove-Directory -Path (Join-Path $CopilotConfigDir 'agents') -Description 'Copilot agents'
}

# Uninstall prompts
function Uninstall-Prompts {
    Write-Info "=== Removing Prompts ==="
    Remove-Directory -Path (Join-Path $HomeDir '.config/ai-prompts') -Description 'prompts'
}

# Uninstall MCP
function Uninstall-MCP {
    Write-Info "=== Removing MCP Configurations ==="
    Remove-Directory -Path (Join-Path $MCPConfigDir 'servers') -Description 'MCP servers'
    Remove-Directory -Path (Join-Path $MCPConfigDir 'clients') -Description 'MCP clients'
    Remove-Directory -Path (Join-Path $MCPConfigDir 'custom') -Description 'Custom MCP'
}

# Uninstall tools
function Uninstall-Tools {
    Write-Info "=== Removing Tools ==="
    Remove-Directory -Path $ToolsDir -Description 'tools'
}

# Uninstall modes
function Uninstall-Modes {
    Write-Info "=== Removing Modes ==="
    Remove-Directory -Path $ModesDir -Description 'modes'
}

# Main uninstall logic
function Main {
    Write-Info "AI Agent Customizations Uninstall"
    
    if ($DryRun) {
        Write-Warning "DRY RUN MODE - No changes will be made"
    }
    
    Write-Host ""
    
    # Process components
    foreach ($comp in $Component) {
        switch ($comp) {
            'all' {
                Uninstall-Agents
                Uninstall-Prompts
                Uninstall-MCP
                Uninstall-Tools
                Uninstall-Modes
            }
            'agents' { Uninstall-Agents }
            'prompts' { Uninstall-Prompts }
            'mcp' { Uninstall-MCP }
            'tools' { Uninstall-Tools }
            'modes' { Uninstall-Modes }
        }
        Write-Host ""
    }
    
    if ($DryRun) {
        Write-Info "Dry run complete. Run without -DryRun to apply changes."
    } else {
        Write-Success "Uninstall complete!"
    }
}

# Run main
Main
