#Requires -Version 5.1

<#
.SYNOPSIS
    Git Repository Status Overview
.DESCRIPTION
    Provides a quick overview of git repository status across multiple repositories
.EXAMPLE
    .\git-status-overview.ps1
    Show status of all git repositories in current directory and subdirectories
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

# Find all git repositories
function Find-GitRepos {
    Get-ChildItem -Directory -Recurse -Depth 2 -Force -ErrorAction SilentlyContinue | 
        Where-Object { Test-Path (Join-Path $_.FullName '.git') } |
        ForEach-Object { $_.FullName }
}

# Get status for a single repository
function Get-RepoStatus {
    param([string]$RepoPath)
    
    Push-Location $RepoPath
    try {
        # Get branch name
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if (-not $branch) { $branch = "unknown" }
        
        # Check for uncommitted changes
        $statusOutput = git status --short 2>$null
        $status = if ($statusOutput) { "MODIFIED" } else { "CLEAN" }
        
        # Check for unpushed commits
        $unpushed = (git log "@{u}.." --oneline 2>$null | Measure-Object).Count
        if ($LASTEXITCODE -ne 0) { $unpushed = 0 }
        
        [PSCustomObject]@{
            Repository = $RepoPath
            Branch = $branch
            Status = $status
            Unpushed = $unpushed
        }
    }
    finally {
        Pop-Location
    }
}

# Main
Write-Host ""
Write-Host "Git Repository Status Overview" -ForegroundColor Cyan
Write-Host ("=" * 80)

$repos = Find-GitRepos

if ($repos.Count -eq 0) {
    Write-Host "No git repositories found in current directory." -ForegroundColor Yellow
    exit
}

$results = @()
foreach ($repo in $repos) {
    $results += Get-RepoStatus -RepoPath $repo
}

# Display results
$results | Format-Table -Property @{
    Label = "Repository"
    Expression = { $_.Repository }
    Width = 50
}, @{
    Label = "Branch"
    Expression = { $_.Branch }
    Width = 15
}, @{
    Label = "Status"
    Expression = { $_.Status }
    Width = 10
}, @{
    Label = "Unpushed"
    Expression = { $_.Unpushed }
} -AutoSize

Write-Host ("=" * 80)
Write-Host ""
