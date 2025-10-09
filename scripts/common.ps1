#Requires -Version 5.1

<#
.SYNOPSIS
    Common functions shared across installation scripts
#>

Set-StrictMode -Version Latest

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

# Get repository root directory
function Get-RepoRoot {
    param([string]$ScriptDir)
    return Split-Path $ScriptDir -Parent
}

# Get home directory (cross-platform)
function Get-HomeDirectory {
    if ($env:USERPROFILE) { return $env:USERPROFILE } else { return $env:HOME }
}

# Get configuration directories
function Get-ConfigDirectories {
    $homeDir = Get-HomeDirectory
    
    return @{
        Claude = @{
            Root = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $homeDir '.claude' }
        }
        Copilot = @{
            Root = if ($env:COPILOT_CONFIG_DIR) { $env:COPILOT_CONFIG_DIR } elseif ($env:APPDATA) { Join-Path $env:APPDATA 'Code' 'User' } else { Join-Path $homeDir '.config/github-copilot' }
        }
        Shared = @{
            Prompts = if ($env:PROMPTS_DIR) { $env:PROMPTS_DIR } else { Join-Path $homeDir '.config/ai-prompts' }
            MCP = if ($env:MCP_CONFIG_DIR) { $env:MCP_CONFIG_DIR } else { Join-Path $homeDir '.config/mcp' }
            Tools = if ($env:TOOLS_DIR) { $env:TOOLS_DIR } elseif ($env:LOCALAPPDATA) { Join-Path $env:LOCALAPPDATA 'ai-tools' } else { Join-Path $homeDir '.local/share/ai-tools' }
            Modes = if ($env:MODES_DIR) { $env:MODES_DIR } else { Join-Path $homeDir '.config/ai-modes' }
        }
    }
}

# Get valid customization types for a tool
function Get-ValidTypes {
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('claude', 'copilot')]
        [string]$Tool,
        
        [Parameter(Mandatory=$true)]
        [string]$RepoRoot
    )
    
    $toolDir = Join-Path $RepoRoot $Tool
    if (Test-Path $toolDir) {
        $dirs = Get-ChildItem -Path $toolDir -Directory | Select-Object -ExpandProperty Name
        return $dirs
    }
    return @()
}

# Process include directives in file content
function Resolve-Includes {
    param(
        [string]$Content,
        [string]$RepoRoot
    )
    
    $processedContent = $Content
    $includePattern = '\{\{include:([^}]+)\}\}'
    
    while ($processedContent -match $includePattern) {
        $includeMatches = [regex]::Matches($processedContent, $includePattern)
        
        foreach ($match in $includeMatches) {
            $includeDirective = $match.Value
            $includePath = $match.Groups[1].Value
            $includeFile = Join-Path $RepoRoot $includePath
            
            if (Test-Path $includeFile) {
                $includeContent = Get-Content -Path $includeFile -Raw -Encoding UTF8
                # Remove any BOM
                $includeContent = $includeContent -replace '^\uFEFF', ''
                $processedContent = $processedContent -replace [regex]::Escape($includeDirective), $includeContent
            } else {
                Write-Warning "Include file not found: $includeFile"
                # Remove the include directive to prevent infinite loops
                $processedContent = $processedContent -replace [regex]::Escape($includeDirective), ""
            }
        }
    }
    
    return $processedContent
}

# Process template placeholders in content
function Resolve-TemplatePlaceholders {
    param(
        [string]$Content,
        [hashtable]$Replacements
    )
    
    $processedContent = $Content
    
    foreach ($key in $Replacements.Keys) {
        $placeholder = "{{$key}}"
        $processedContent = $processedContent -replace [regex]::Escape($placeholder), $Replacements[$key]
    }
    
    return $processedContent
}

# Create a backup of a file
function Backup-File {
    param(
        [string]$FilePath,
        [switch]$DryRun
    )
    
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

# All functions are automatically available when dot-sourced
# No Export-ModuleMember needed
