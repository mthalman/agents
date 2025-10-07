#!/usr/bin/env bash

# Template Generator Script
# Quickly create new customization files from templates

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

usage() {
    cat << EOF
Template Generator - Quickly create new customization files

Usage: $0 [TYPE] [NAME]

TYPE:
    agent               Create a new custom agent
    prompt              Create a new prompt template
    mcp-server          Create a new MCP server configuration
    tool-script         Create a new tool script
    mode-profile        Create a new mode profile

EXAMPLES:
    # Create a new custom agent
    $0 agent my-code-reviewer

    # Create a new prompt template
    $0 prompt git-commit-message

    # Create a new MCP server config
    $0 mcp-server filesystem

    # Create a new tool script
    $0 tool-script backup-configs

    # Create a new mode profile
    $0 mode-profile writing-mode
EOF
}

# Generate custom agent template
generate_agent() {
    local name="$1"
    local filename="${REPO_ROOT}/agents/custom/${name}.md"
    
    if [[ -f "$filename" ]]; then
        log_info "File already exists: $filename"
        read -p "Overwrite? [y/N] " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && return
    fi
    
    cat > "$filename" << EOF
# Custom Agent: ${name}

## Agent Metadata
- **Name**: ${name}
- **Type**: Custom
- **Purpose**: [Describe the purpose of this agent]
- **Created**: $(date +%Y-%m-%d)

## Instructions

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
EOF
    
    log_success "Created agent: $filename"
    log_info "Edit the file to customize your agent"
}

# Generate prompt template
generate_prompt() {
    local name="$1"
    local filename="${REPO_ROOT}/prompts/templates/${name}.md"
    
    if [[ -f "$filename" ]]; then
        log_info "File already exists: $filename"
        read -p "Overwrite? [y/N] " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && return
    fi
    
    cat > "$filename" << EOF
# Prompt: ${name}
# Tool: [Claude/Copilot/Universal]
# Purpose: [Brief description of what this prompt does]
# Tags: [tag1, tag2, tag3]
# Created: $(date +%Y-%m-%d)

[Your prompt content here]

## Variables

If using template variables, document them here:
- {variable1} - Description
- {variable2} - Description

## Usage Examples

### Example 1
\`\`\`
[Show how to use this prompt]
\`\`\`

### Example 2
\`\`\`
[Another usage example]
\`\`\`

## Tips

- [Tip 1 for using this prompt effectively]
- [Tip 2]
EOF
    
    log_success "Created prompt template: $filename"
    log_info "Edit the file to add your prompt content"
}

# Generate MCP server configuration
generate_mcp_server() {
    local name="$1"
    local filename="${REPO_ROOT}/mcp/servers/${name}.json"
    
    if [[ -f "$filename" ]]; then
        log_info "File already exists: $filename"
        read -p "Overwrite? [y/N] " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && return
    fi
    
    cat > "$filename" << EOF
{
  "mcpServers": {
    "${name}": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-${name}"
      ],
      "env": {
        "API_KEY": "your-api-key-here"
      },
      "description": "MCP server for ${name}"
    }
  }
}
EOF
    
    log_success "Created MCP server config: $filename"
    log_info "Edit the file to configure your server"
}

# Generate tool script
generate_tool_script() {
    local name="$1"
    local filename="${REPO_ROOT}/tools/scripts/${name}.sh"
    
    if [[ -f "$filename" ]]; then
        log_info "File already exists: $filename"
        read -p "Overwrite? [y/N] " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && return
    fi
    
    cat > "$filename" << 'EOF'
#!/usr/bin/env bash

# Tool Script: ${name}
# Description: [Describe what this script does]
# Created: $(date +%Y-%m-%d)

set -e

# Usage information
usage() {
    cat << USAGE
${name} - [Brief description]

Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help      Show this help message
    [Add your options here]

EXAMPLES:
    # Example 1
    $0 [example usage]

USAGE
}

# Main function
main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    # Your script logic here
    echo "Running ${name}..."
    
    # Add your code here
}

# Run main
main "$@"
EOF
    
    chmod +x "$filename"
    log_success "Created tool script: $filename"
    log_info "Script is executable and ready to edit"
}

# Generate mode profile
generate_mode_profile() {
    local name="$1"
    local filename="${REPO_ROOT}/modes/profiles/${name}.md"
    
    if [[ -f "$filename" ]]; then
        log_info "File already exists: $filename"
        read -p "Overwrite? [y/N] " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && return
    fi
    
    cat > "$filename" << EOF
# ${name} Mode Profile

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
\`\`\`
[Example prompt for this mode]
\`\`\`

### Prompt 2
\`\`\`
[Another example prompt]
\`\`\`

## Related Modes

- [Other mode 1] - [When to use instead]
- [Other mode 2] - [When to use instead]
EOF
    
    log_success "Created mode profile: $filename"
    log_info "Edit the file to customize your mode"
}

# Main
if [[ $# -lt 2 ]]; then
    usage
    exit 1
fi

TYPE="$1"
NAME="$2"

case "$TYPE" in
    agent)
        generate_agent "$NAME"
        ;;
    prompt)
        generate_prompt "$NAME"
        ;;
    mcp-server)
        generate_mcp_server "$NAME"
        ;;
    tool-script)
        generate_tool_script "$NAME"
        ;;
    mode-profile)
        generate_mode_profile "$NAME"
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    *)
        echo "Unknown type: $TYPE"
        usage
        exit 1
        ;;
esac
