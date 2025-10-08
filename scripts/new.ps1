#Requires -Version 5.1

<#
.SYNOPSIS
    Template Generator - Quickly create new customization files
.DESCRIPTION
    This script generates new customization files from templates.
.PARAMETER Type
    Type of template to create (agent, prompt, mcp-server, tool-script, mode-profile)
.PARAMETER Name
    Name for the new customization
.PARAMETER Tool
    For agents: specify tool (unified, claude, copilot). Default is 'unified' for cross-tool agents.
.EXAMPLE
    .\new.ps1 -Type agent -Name my-code-reviewer
    Create a unified agent (works with both Claude and Copilot)
.EXAMPLE
    .\new.ps1 -Type agent -Name my-claude-agent -Tool claude
    Create a Claude-specific agent
.EXAMPLE
    .\new.ps1 -Type prompt -Name git-commit-message
    Create a new prompt template
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('agent', 'prompt', 'mcp-server', 'tool-script', 'mode-profile')]
    [string]$Type,
    
    [Parameter(Mandatory=$true)]
    [string]$Name,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet('unified', 'claude', 'copilot')]
    [string]$Tool = 'unified'
)

$ErrorActionPreference = 'Stop'

$ScriptDir = $PSScriptRoot
$RepoRoot = Split-Path $ScriptDir -Parent

# Logging functions
function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

# Generate custom agent template
function New-AgentTemplate {
    param(
        [string]$AgentName,
        [string]$ToolType
    )
    
    # Determine the path based on tool type
    $agentPath = switch ($ToolType) {
        'claude' { Join-Path $RepoRoot "agents\claude\$AgentName.md" }
        'copilot' { Join-Path $RepoRoot "agents\copilot\$AgentName.md" }
        default { Join-Path $RepoRoot "agents\$AgentName.md" }
    }
    
    if (Test-Path $agentPath) {
        Write-Info "File already exists: $agentPath"
        $response = Read-Host "Overwrite? [y/N]"
        if ($response -ne 'y' -and $response -ne 'Y') {
            return
        }
    }
    
    # Ensure directory exists
    $dir = Split-Path $agentPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    
    $date = Get-Date -Format 'yyyy-MM-dd'
    
    # Use Claude Code CLI format (YAML frontmatter) for all agents
    # This format works for both Claude and Copilot
    $content = @"
---
name: $AgentName
description: [Brief description of what this agent does]
---

You are a specialized AI assistant designed to [describe the main function].

Your key responsibilities:

1. **Primary Function**
   - [Describe what the agent does]
   
2. **Capabilities**
   - [List specific capabilities]
   - [Use bullet points]
   
3. **Constraints**
   - [List any limitations or rules]
   
4. **Output Format**
   - [Describe expected output format]

## Examples

### Example 1
**Input**: [Sample input]
**Output**: [Expected output]

### Example 2
**Input**: [Sample input]
**Output**: [Expected output]

## Notes

- [Add any important notes]
- [Include tips for using this agent]
- Created: $date
"@
    
    $content | Out-File -FilePath $agentPath -Encoding UTF8
    
    $toolInfo = if ($ToolType -eq 'unified') { 'unified (works with Claude & Copilot)' } else { "$ToolType-specific" }
    Write-Success "Created $toolInfo agent: $agentPath"
    Write-Info "Edit the file to customize your agent"
}

# Generate prompt template
function New-PromptTemplate {
    param([string]$PromptName)
    
    $filename = Join-Path $RepoRoot "prompts\templates\$PromptName.md"
    
    if (Test-Path $filename) {
        Write-Info "File already exists: $filename"
        $response = Read-Host "Overwrite? [y/N]"
        if ($response -ne 'y' -and $response -ne 'Y') {
            return
        }
    }
    
    # Ensure directory exists
    $dir = Split-Path $filename -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    
    $date = Get-Date -Format 'yyyy-MM-dd'
    $content = @"
# Prompt: $PromptName
# Tool: [Claude/Copilot/Universal]
# Purpose: [Brief description of what this prompt does]
# Tags: [tag1, tag2, tag3]
# Created: $date

[Your prompt content here]

## Variables

If using template variables, document them here:
- {variable1} - Description
- {variable2} - Description

## Usage Examples

### Example 1
``````
[Show how to use this prompt]
``````

### Example 2
``````
[Another usage example]
``````

## Tips

- [Tip 1 for using this prompt effectively]
- [Tip 2]
"@
    
    $content | Out-File -FilePath $filename -Encoding UTF8
    Write-Success "Created prompt template: $filename"
    Write-Info "Edit the file to add your prompt content"
}

# Generate MCP server configuration
function New-MCPServerConfig {
    param([string]$ServerName)
    
    $filename = Join-Path $RepoRoot "mcp\servers\$ServerName.json"
    
    if (Test-Path $filename) {
        Write-Info "File already exists: $filename"
        $response = Read-Host "Overwrite? [y/N]"
        if ($response -ne 'y' -and $response -ne 'Y') {
            return
        }
    }
    
    # Ensure directory exists
    $dir = Split-Path $filename -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    
    $content = @"
{
  "mcpServers": {
    "$ServerName": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-$ServerName"
      ],
      "env": {
        "API_KEY": "your-api-key-here"
      },
      "description": "MCP server for $ServerName"
    }
  }
}
"@
    
    $content | Out-File -FilePath $filename -Encoding UTF8
    Write-Success "Created MCP server config: $filename"
    Write-Info "Edit the file to configure your server"
}

# Generate tool script
function New-ToolScript {
    param([string]$ScriptName)
    
    $filename = Join-Path $RepoRoot "tools\scripts\$ScriptName.ps1"
    
    if (Test-Path $filename) {
        Write-Info "File already exists: $filename"
        $response = Read-Host "Overwrite? [y/N]"
        if ($response -ne 'y' -and $response -ne 'Y') {
            return
        }
    }
    
    # Ensure directory exists
    $dir = Split-Path $filename -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    
    $date = Get-Date -Format 'yyyy-MM-dd'
    $content = @"
#Requires -Version 5.1

<#
.SYNOPSIS
    $ScriptName - [Brief description]
.DESCRIPTION
    [Detailed description of what this script does]
.EXAMPLE
    .\$ScriptName.ps1
    [Example usage]
#>

[CmdletBinding()]
param(
    # Add your parameters here
)

`$ErrorActionPreference = 'Stop'

# Created: $date

# Main function
function Main {
    Write-Host "Running $ScriptName..."
    
    # Add your code here
}

# Run main
Main
"@
    
    $content | Out-File -FilePath $filename -Encoding UTF8
    Write-Success "Created tool script: $filename"
    Write-Info "Script is ready to edit"
}

# Generate mode profile
function New-ModeProfile {
    param([string]$ModeName)
    
    $filename = Join-Path $RepoRoot "modes\profiles\$ModeName.md"
    
    if (Test-Path $filename) {
        Write-Info "File already exists: $filename"
        $response = Read-Host "Overwrite? [y/N]"
        if ($response -ne 'y' -and $response -ne 'Y') {
            return
        }
    }
    
    # Ensure directory exists
    $dir = Split-Path $filename -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    
    $content = @"
# $ModeName Mode Profile

## Overview

This mode is optimized for [describe the use case].

## Configuration

### Enabled Features
- [Feature 1]
- [Feature 2]
- [Feature 3]

### Preferred Tools
- [Tool 1]
- [Tool 2]
- [Tool 3]

### Agent Settings
- **Temperature**: [0.0-1.0]
- **Max Tokens**: [number]
- **Focus Areas**: [List focus areas]

### Prompt Enhancements
- [Enhancement 1]
- [Enhancement 2]
- [Enhancement 3]

## MCP Servers

Recommended MCP servers for this mode:
- [Server 1] - [Purpose]
- [Server 2] - [Purpose]

## When to Use

Activate this mode when:
- [Scenario 1]
- [Scenario 2]
- [Scenario 3]

## Tips

1. [Tip 1 for using this mode]
2. [Tip 2]
3. [Tip 3]

## Example Prompts

### Prompt 1
``````
[Example prompt for this mode]
``````

### Prompt 2
``````
[Another example prompt]
``````

## Related Modes

- [Other mode 1] - [When to use instead]
- [Other mode 2] - [When to use instead]
"@
    
    $content | Out-File -FilePath $filename -Encoding UTF8
    Write-Success "Created mode profile: $filename"
    Write-Info "Edit the file to customize your mode"
}

# Main
switch ($Type) {
    'agent' { New-AgentTemplate -AgentName $Name -ToolType $Tool }
    'prompt' { New-PromptTemplate -PromptName $Name }
    'mcp-server' { New-MCPServerConfig -ServerName $Name }
    'tool-script' { New-ToolScript -ScriptName $Name }
    'mode-profile' { New-ModeProfile -ModeName $Name }
}
