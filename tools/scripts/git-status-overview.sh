#!/usr/bin/env bash

# Example Tool Script: Quick Git Status
# This script provides a quick overview of git repository status

set -e

# Find all git repositories in the current directory and subdirectories
find_git_repos() {
    find . -name ".git" -type d -prune | while read -r git_dir; do
        repo_dir=$(dirname "$git_dir")
        echo "$repo_dir"
    done
}

# Get status for a single repository
get_repo_status() {
    local repo="$1"
    cd "$repo"
    
    # Get branch name
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    
    # Check for uncommitted changes
    if [[ -n $(git status -s) ]]; then
        status="MODIFIED"
    else
        status="CLEAN"
    fi
    
    # Check for unpushed commits
    unpushed=$(git log @{u}.. --oneline 2>/dev/null | wc -l || echo "0")
    
    printf "%-50s %-15s %-10s Unpushed: %s\n" "$repo" "$branch" "$status" "$unpushed"
}

echo "Git Repository Status Overview"
echo "=================================================================="
printf "%-50s %-15s %-10s %s\n" "Repository" "Branch" "Status" "Commits"
echo "=================================================================="

find_git_repos | while read -r repo; do
    get_repo_status "$repo"
done

echo "=================================================================="
