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
.PARAMETER ShowExtra
    Only show extra files summary without installing
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
.EXAMPLE
    .\install.ps1 -ShowExtra
    Show only extra files that exist in install locations but not in source
#>

[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Force,
    [switch]$Backup,
    [switch]$ShowExtra,
    [ValidateSet('all', 'claude', 'copilot')]
    [string[]]$Tool = @('all')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Get repository root
$ScriptDir = $PSScriptRoot
$RepoRoot = if ($env:TEST_REPO_ROOT) { $env:TEST_REPO_ROOT } else { Split-Path $ScriptDir -Parent }

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

# Check for extra files in destination that don't exist in source
function Get-ExtraFiles {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Description
    )

    $extraFiles = @()

    if (-not (Test-Path $Destination)) {
        return $extraFiles
    }

    $destFiles = Get-ChildItem -Path $Destination -File -Recurse -ErrorAction SilentlyContinue | Where-Object {
        $_.Name -ne 'README.md' -and $_.Name -ne '.template.md'
    }

    if ($destFiles) {
        foreach ($destFile in $destFiles) {
            $relativePath = $destFile.FullName.Substring($Destination.Length + 1)
            $sourceFile = Join-Path $Source $relativePath

            if (-not (Test-Path $sourceFile)) {
                $extraFiles += [PSCustomObject]@{
                    Path = $relativePath
                    FullPath = $destFile.FullName
                    Size = $destFile.Length
                    LastModified = $destFile.LastWriteTime
                }
            }
        }
    }

    return $extraFiles
}

# Process and display extra files for a specific location
function Process-ExtraFiles {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$Description,
        [string]$DisplayName
    )

    $extraFiles = @(Get-ExtraFiles -Source $Source -Destination $Destination -Description $Description)

    if ($extraFiles.Count -gt 0) {
        Write-Info "$DisplayName ($Destination):"
        foreach ($file in $extraFiles) {
            Write-Host "  📄 $($file.Path) ($(Format-FileSize $file.Size), modified $($file.LastModified.ToString('yyyy-MM-dd')))" -ForegroundColor Yellow
        }
        Write-Host ""
    }

    return $extraFiles
}

# Summarize extra files across all install locations
function Show-ExtraFilesSummary {
    param(
        [switch]$AllowDelete
    )

    Write-Info "=== Extra Files Summary ==="
    Write-Info "Files that exist in install locations but not in source repository:"
    Write-Host ""

    $allExtraFiles = @()

    # Define location mappings
    $locationMappings = @()

    # Add Claude locations if applicable
    if ('claude' -in $Tool -or 'all' -in $Tool) {
        $locationMappings += @{
            Source = Join-Path $RepoRoot 'claude/agents'
            Destination = $ClaudeAgentsDir
            Description = 'Claude agents'
            DisplayName = 'Claude Agents'
        }
        $locationMappings += @{
            Source = Join-Path $RepoRoot 'claude/commands'
            Destination = $ClaudeCommandsDir
            Description = 'Claude commands'
            DisplayName = 'Claude Commands'
        }
        $locationMappings += @{
            Source = Join-Path $RepoRoot 'claude/output-styles'
            Destination = $ClaudeOutputStylesDir
            Description = 'Claude output styles'
            DisplayName = 'Claude Output Styles'
        }
    }

    # Add Copilot locations if applicable
    if ('copilot' -in $Tool -or 'all' -in $Tool) {
        $locationMappings += @{
            Source = Join-Path $RepoRoot 'copilot/modes'
            Destination = $CopilotModesDir
            Description = 'Copilot modes'
            DisplayName = 'Copilot Modes'
        }
        $locationMappings += @{
            Source = Join-Path $RepoRoot 'copilot/prompts'
            Destination = $CopilotPromptsDir
            Description = 'Copilot prompts'
            DisplayName = 'Copilot Prompts'
        }
    }

    # Process each location and collect extra files
    foreach ($location in $locationMappings) {
        $extraFiles = Process-ExtraFiles @location
        $allExtraFiles += $extraFiles
    }

    $totalExtraFiles = $allExtraFiles.Count
    $hasExtraFiles = $totalExtraFiles -gt 0

    if (-not $hasExtraFiles) {
        Write-Success "✅ No extra files found - install locations match source repository"
    } else {
        Write-Warning "⚠️  Found $totalExtraFiles extra file(s) in install locations"
        Write-Info "These files may be:"
        Write-Info "  • Custom configurations you've created"
        Write-Info "  • Files from previous installations"
        Write-Info "  • Backup files that weren't cleaned up"
        Write-Info ""

        # Prompt for deletion if allowed and not in DryRun mode
        # Skip interactive prompts in test environments
        $isInTest = $false
        try {
            # Check if we're running in a Pester test context
            $isInTest = (Get-Command 'Describe' -ErrorAction SilentlyContinue) -and
                       (Get-Variable 'PesterPreference' -ErrorAction SilentlyContinue)
        } catch {
            $isInTest = $false
        }

        if ($AllowDelete -and -not $DryRun -and -not $isInTest) {
            Write-Host ""
            Write-Warning "Delete Extra Files?"
            Write-Host "You can choose to delete files individually or all at once." -ForegroundColor Yellow
            Write-Host ""

            $response = Read-Host "How would you like to proceed? (each/all/skip) [skip]"

            switch (($response ?? "skip").ToLower()) {
                'all' {
                    Write-Info "Deleting all extra files..."
                    $deletedCount = 0
                    foreach ($file in $allExtraFiles) {
                        try {
                            Remove-Item -Path $file.FullPath -Force
                            Write-Success "  ✓ Deleted: $($file.Path)"
                            $deletedCount++
                        } catch {
                            Write-Warning "  ✗ Failed to delete: $($file.Path) - $_"
                        }
                    }
                    Write-Success "Deleted $deletedCount of $totalExtraFiles extra file(s)"
                    Write-Host ""
                }
                'each' {
                    Write-Info "Reviewing each file individually..."
                    Write-Info "Options: y=yes (delete), n=no (keep), all=delete all remaining, stop=stop reviewing"
                    Write-Host ""
                    $deletedCount = 0
                    $keepCount = 0
                    $skipCount = 0

                    for ($i = 0; $i -lt $allExtraFiles.Count; $i++) {
                        $file = $allExtraFiles[$i]
                        $remaining = $allExtraFiles.Count - $i

                        Write-Host "File $($i + 1) of $($allExtraFiles.Count): $($file.Path)" -ForegroundColor Cyan
                        Write-Host "  Size: $(Format-FileSize $file.Size)"
                        Write-Host "  Modified: $($file.LastModified.ToString('yyyy-MM-dd HH:mm'))"

                        $fileResponse = Read-Host "Delete this file? (y/n/all/stop) [n]"

                        switch (($fileResponse ?? "n").ToLower()) {
                            'y' {
                                try {
                                    Remove-Item -Path $file.FullPath -Force
                                    Write-Success "  ✓ Deleted: $($file.Path)"
                                    $deletedCount++
                                } catch {
                                    Write-Warning "  ✗ Failed to delete: $($file.Path) - $_"
                                }
                            }
                            'all' {
                                Write-Info "Deleting all remaining files..."
                                for ($j = $i; $j -lt $allExtraFiles.Count; $j++) {
                                    $remainingFile = $allExtraFiles[$j]
                                    try {
                                        Remove-Item -Path $remainingFile.FullPath -Force
                                        Write-Success "  ✓ Deleted: $($remainingFile.Path)"
                                        $deletedCount++
                                    } catch {
                                        Write-Warning "  ✗ Failed to delete: $($remainingFile.Path) - $_"
                                    }
                                }
                                $skipCount = $remaining - 1
                                break
                            }
                            'stop' {
                                Write-Info "Stopped reviewing files."
                                $skipCount = $remaining - 1
                                break
                            }
                            default {
                                Write-Info "  ✓ Kept: $($file.Path)"
                                $keepCount++
                            }
                        }

                        if ($fileResponse.ToLower() -eq 'all' -or $fileResponse.ToLower() -eq 'stop') {
                            break
                        }

                        Write-Host ""
                    }

                    if ($skipCount -gt 0) {
                        Write-Info "Summary: Deleted $deletedCount file(s), kept $keepCount file(s), skipped $skipCount file(s)"
                    } else {
                        Write-Info "Summary: Deleted $deletedCount file(s), kept $keepCount file(s)"
                    }
                    Write-Host ""
                }
                default {
                    Write-Info "Extra files were not deleted."
                }
            }
        } elseif ($isInTest) {
            Write-Info "Running in test environment - skipping interactive prompts"
        } elseif (-not $AllowDelete) {
            Write-Info "Consider backing up important custom files before running with -Force"
        }
    }

    Write-Host ""
}

# Format file size in human-readable format
function Format-FileSize {
    param([long]$Size)

    if ($Size -lt 1KB) { return "$Size B" }
    elseif ($Size -lt 1MB) { return "{0:N1} KB" -f ($Size / 1KB) }
    elseif ($Size -lt 1GB) { return "{0:N1} MB" -f ($Size / 1MB) }
    else { return "{0:N1} GB" -f ($Size / 1GB) }
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

    if ($ShowExtra) {
        # Only show extra files summary and exit
        Show-ExtraFilesSummary -AllowDelete
        return
    }

    if ($DryRun) {
        Write-Warning "DRY RUN MODE - No changes will be made"
    }

    Write-Host ""

    # Show extra files summary before installation
    # Allow deletion prompt only if not in DryRun mode
    Show-ExtraFilesSummary -AllowDelete:(-not $DryRun)

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
