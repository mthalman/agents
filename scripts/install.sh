#!/usr/bin/env bash

# AI Agent Customizations Installation Script
# This script helps deploy customizations from this repository to your system

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

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
AI Agent Customizations Installation Script

Usage: $0 [OPTIONS] [COMPONENT]

OPTIONS:
    -h, --help              Show this help message
    -n, --dry-run          Show what would be installed without making changes
    -f, --force            Overwrite existing files
    -b, --backup           Create backups of existing files before overwriting
    -v, --verbose          Enable verbose output

COMPONENT:
    all                     Install all components (default)
    agents                  Install agent configurations
    prompts                 Install prompts
    mcp                     Install MCP configurations
    tools                   Install tools
    modes                   Install modes

ENVIRONMENT VARIABLES:
    CLAUDE_CONFIG_DIR       Claude configuration directory (default: ~/.config/claude)
    COPILOT_CONFIG_DIR      GitHub Copilot configuration directory (default: ~/.config/github-copilot)
    MCP_CONFIG_DIR          MCP configuration directory (default: ~/.config/mcp)
    TOOLS_DIR               Tools installation directory (default: ~/.local/share/ai-tools)
    MODES_DIR               Modes configuration directory (default: ~/.config/ai-modes)

EXAMPLES:
    # Install all components
    $0

    # Dry run to see what would be installed
    $0 --dry-run

    # Install only MCP configurations with backup
    $0 --backup mcp

    # Force install agents and prompts
    $0 --force agents prompts
EOF
}

# Parse command line arguments
DRY_RUN=false
FORCE=false
BACKUP=false
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
        -b|--backup)
            BACKUP=true
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

# Create a backup of a file
backup_file() {
    local file="$1"
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    if [[ -f "$file" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log_info "Would backup: $file -> $backup"
        else
            cp -p "$file" "$backup"
            log_success "Created backup: $backup"
        fi
    fi
}

# Copy files from source to destination
install_files() {
    local src="$1"
    local dest="$2"
    local description="$3"
    
    log_info "Installing $description..."
    
    # Create destination directory
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Would create directory: $dest"
    else
        mkdir -p "$dest"
        [[ "$VERBOSE" == true ]] && log_info "Created directory: $dest"
    fi
    
    # Check if source directory exists and has files
    if [[ ! -d "$src" ]]; then
        log_warning "Source directory not found: $src"
        return
    fi
    
    # Count files to install
    local file_count=$(find "$src" -type f ! -name "README.md" 2>/dev/null | wc -l)
    if [[ $file_count -eq 0 ]]; then
        log_warning "No files to install in $src"
        return
    fi
    
    # Copy files
    find "$src" -type f ! -name "README.md" | while read -r file; do
        local rel_path="${file#$src/}"
        local dest_file="$dest/$rel_path"
        local dest_dir="$(dirname "$dest_file")"
        
        # Create subdirectories
        if [[ "$DRY_RUN" == true ]]; then
            [[ "$VERBOSE" == true ]] && log_info "Would create: $dest_dir"
        else
            mkdir -p "$dest_dir"
        fi
        
        # Handle existing files
        if [[ -f "$dest_file" ]]; then
            if [[ "$FORCE" == false ]]; then
                log_warning "File exists (use --force to overwrite): $dest_file"
                return
            fi
            
            if [[ "$BACKUP" == true ]]; then
                backup_file "$dest_file"
            fi
        fi
        
        # Copy file
        if [[ "$DRY_RUN" == true ]]; then
            log_info "Would install: $rel_path -> $dest_file"
        else
            cp -p "$file" "$dest_file"
            [[ "$VERBOSE" == true ]] && log_success "Installed: $rel_path"
        fi
    done
    
    log_success "Finished installing $description"
}

# Install agents
install_agents() {
    log_info "=== Installing Agent Configurations ==="
    
    # Claude agents
    if [[ -d "$REPO_ROOT/agents/claude" ]]; then
        install_files "$REPO_ROOT/agents/claude" "$CLAUDE_CONFIG_DIR/agents" "Claude agents"
    fi
    
    # Copilot agents
    if [[ -d "$REPO_ROOT/agents/copilot" ]]; then
        install_files "$REPO_ROOT/agents/copilot" "$COPILOT_CONFIG_DIR/agents" "Copilot agents"
    fi
    
    # Custom agents
    if [[ -d "$REPO_ROOT/agents/custom" ]]; then
        install_files "$REPO_ROOT/agents/custom" "$HOME/.config/ai-agents/custom" "Custom agents"
    fi
}

# Install prompts
install_prompts() {
    log_info "=== Installing Prompts ==="
    install_files "$REPO_ROOT/prompts" "$HOME/.config/ai-prompts" "prompts"
}

# Install MCP configurations
install_mcp() {
    log_info "=== Installing MCP Configurations ==="
    
    # MCP servers
    if [[ -d "$REPO_ROOT/mcp/servers" ]]; then
        install_files "$REPO_ROOT/mcp/servers" "$MCP_CONFIG_DIR/servers" "MCP servers"
    fi
    
    # MCP clients
    if [[ -d "$REPO_ROOT/mcp/clients" ]]; then
        install_files "$REPO_ROOT/mcp/clients" "$MCP_CONFIG_DIR/clients" "MCP clients"
    fi
    
    # Custom MCP
    if [[ -d "$REPO_ROOT/mcp/custom" ]]; then
        install_files "$REPO_ROOT/mcp/custom" "$MCP_CONFIG_DIR/custom" "Custom MCP"
    fi
}

# Install tools
install_tools() {
    log_info "=== Installing Tools ==="
    
    # Scripts
    if [[ -d "$REPO_ROOT/tools/scripts" ]]; then
        install_files "$REPO_ROOT/tools/scripts" "$TOOLS_DIR/scripts" "tool scripts"
        
        # Make scripts executable
        if [[ "$DRY_RUN" == false ]]; then
            find "$TOOLS_DIR/scripts" -type f -name "*.sh" -exec chmod +x {} \;
            [[ "$VERBOSE" == true ]] && log_info "Made scripts executable"
        fi
    fi
    
    # Plugins
    if [[ -d "$REPO_ROOT/tools/plugins" ]]; then
        install_files "$REPO_ROOT/tools/plugins" "$TOOLS_DIR/plugins" "tool plugins"
    fi
    
    # Integrations
    if [[ -d "$REPO_ROOT/tools/integrations" ]]; then
        install_files "$REPO_ROOT/tools/integrations" "$TOOLS_DIR/integrations" "integrations"
    fi
}

# Install modes
install_modes() {
    log_info "=== Installing Modes ==="
    install_files "$REPO_ROOT/modes" "$MODES_DIR" "modes"
}

# Main installation logic
main() {
    log_info "AI Agent Customizations Installation"
    log_info "Repository: $REPO_ROOT"
    
    if [[ "$DRY_RUN" == true ]]; then
        log_warning "DRY RUN MODE - No changes will be made"
    fi
    
    echo ""
    
    # Process components
    for component in "${COMPONENTS[@]}"; do
        case $component in
            all)
                install_agents
                install_prompts
                install_mcp
                install_tools
                install_modes
                ;;
            agents)
                install_agents
                ;;
            prompts)
                install_prompts
                ;;
            mcp)
                install_mcp
                ;;
            tools)
                install_tools
                ;;
            modes)
                install_modes
                ;;
        esac
        echo ""
    done
    
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Dry run complete. Run without --dry-run to apply changes."
    else
        log_success "Installation complete!"
        log_info "You may need to restart your AI tools to pick up the new configurations."
    fi
}

# Run main
main
