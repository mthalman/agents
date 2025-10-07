#!/usr/bin/env bash

# AI Agent Customizations Uninstall Script
# This script helps remove deployed customizations from your system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default installation paths
CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.config/claude}"
COPILOT_CONFIG_DIR="${COPILOT_CONFIG_DIR:-$HOME/.config/github-copilot}"
MCP_CONFIG_DIR="${MCP_CONFIG_DIR:-$HOME/.config/mcp}"
TOOLS_DIR="${TOOLS_DIR:-$HOME/.local/share/ai-tools}"
MODES_DIR="${MODES_DIR:-$HOME/.config/ai-modes}"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Display usage information
usage() {
    cat << EOF
AI Agent Customizations Uninstall Script

Usage: $0 [OPTIONS] [COMPONENT]

OPTIONS:
    -h, --help              Show this help message
    -n, --dry-run          Show what would be removed without making changes
    -f, --force            Remove without confirmation
    -v, --verbose          Enable verbose output

COMPONENT:
    all                     Remove all components (default)
    agents                  Remove agent configurations
    prompts                 Remove prompts
    mcp                     Remove MCP configurations
    tools                   Remove tools
    modes                   Remove modes

EXAMPLES:
    # Remove all components (with confirmation)
    $0

    # Dry run to see what would be removed
    $0 --dry-run

    # Remove only MCP configurations
    $0 mcp
EOF
}

# Parse command line arguments
DRY_RUN=false
FORCE=false
VERBOSE=false
COMPONENTS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        all|agents|prompts|mcp|tools|modes)
            COMPONENTS+=("$1")
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Default to 'all' if no components specified
if [[ ${#COMPONENTS[@]} -eq 0 ]]; then
    COMPONENTS=("all")
fi

# Remove directory with confirmation
remove_directory() {
    local dir="$1"
    local description="$2"
    
    if [[ ! -d "$dir" ]]; then
        [[ "$VERBOSE" == true ]] && log_info "Directory does not exist: $dir"
        return
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Would remove: $dir ($description)"
    else
        if [[ "$FORCE" == false ]]; then
            read -p "Remove $description at $dir? [y/N] " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                log_info "Skipped: $description"
                return
            fi
        fi
        
        rm -rf "$dir"
        log_success "Removed: $description"
    fi
}

# Uninstall agents
uninstall_agents() {
    log_info "=== Removing Agent Configurations ==="
    remove_directory "$CLAUDE_CONFIG_DIR/agents" "Claude agents"
    remove_directory "$COPILOT_CONFIG_DIR/agents" "Copilot agents"
    remove_directory "$HOME/.config/ai-agents/custom" "Custom agents"
}

# Uninstall prompts
uninstall_prompts() {
    log_info "=== Removing Prompts ==="
    remove_directory "$HOME/.config/ai-prompts" "prompts"
}

# Uninstall MCP
uninstall_mcp() {
    log_info "=== Removing MCP Configurations ==="
    remove_directory "$MCP_CONFIG_DIR/servers" "MCP servers"
    remove_directory "$MCP_CONFIG_DIR/clients" "MCP clients"
    remove_directory "$MCP_CONFIG_DIR/custom" "Custom MCP"
}

# Uninstall tools
uninstall_tools() {
    log_info "=== Removing Tools ==="
    remove_directory "$TOOLS_DIR" "tools"
}

# Uninstall modes
uninstall_modes() {
    log_info "=== Removing Modes ==="
    remove_directory "$MODES_DIR" "modes"
}

# Main uninstall logic
main() {
    log_info "AI Agent Customizations Uninstall"
    
    if [[ "$DRY_RUN" == true ]]; then
        log_warning "DRY RUN MODE - No changes will be made"
    fi
    
    echo ""
    
    # Process components
    for component in "${COMPONENTS[@]}"; do
        case $component in
            all)
                uninstall_agents
                uninstall_prompts
                uninstall_mcp
                uninstall_tools
                uninstall_modes
                ;;
            agents)
                uninstall_agents
                ;;
            prompts)
                uninstall_prompts
                ;;
            mcp)
                uninstall_mcp
                ;;
            tools)
                uninstall_tools
                ;;
            modes)
                uninstall_modes
                ;;
        esac
        echo ""
    done
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Dry run complete. Run without --dry-run to apply changes."
    else
        log_success "Uninstall complete!"
    fi
}

# Run main
main
