# Scripts

This directory contains utility scripts for managing AI agent customizations.

## Available Scripts

### new.sh

Quickly create new customization files from templates.

**Usage:**
```bash
./scripts/new.sh [TYPE] [NAME]
```

**Types:**
- `agent` - Create a new custom agent
- `prompt` - Create a new prompt template
- `mcp-server` - Create a new MCP server configuration
- `tool-script` - Create a new tool script
- `mode-profile` - Create a new mode profile

**Examples:**
```bash
# Create a new custom agent
./scripts/new.sh agent my-code-reviewer

# Create a new prompt template
./scripts/new.sh prompt git-commit-message

# Create a new tool script
./scripts/new.sh tool-script backup-configs
```

### install.sh

Installs customizations from this repository to your system.

**Usage:**
```bash
./scripts/install.sh [OPTIONS] [COMPONENT]
```

**Options:**
- `-h, --help` - Show help message
- `-n, --dry-run` - Show what would be installed without making changes
- `-f, --force` - Overwrite existing files
- `-b, --backup` - Create backups before overwriting
- `-v, --verbose` - Enable verbose output

**Components:**
- `all` - Install all components (default)
- `agents` - Install only agent configurations
- `prompts` - Install only prompts
- `mcp` - Install only MCP configurations
- `tools` - Install only tools
- `modes` - Install only modes

**Examples:**
```bash
# Dry run to preview changes
./scripts/install.sh --dry-run

# Install all components
./scripts/install.sh

# Install only MCP configurations with backup
./scripts/install.sh --backup mcp

# Install agents and prompts, forcing overwrite
./scripts/install.sh --force agents prompts
```

### uninstall.sh

Removes installed customizations from your system.

**Usage:**
```bash
./scripts/uninstall.sh [OPTIONS] [COMPONENT]
```

**Options:**
- `-h, --help` - Show help message
- `-n, --dry-run` - Show what would be removed without making changes
- `-f, --force` - Remove without confirmation
- `-v, --verbose` - Enable verbose output

**Examples:**
```bash
# Dry run to preview what would be removed
./scripts/uninstall.sh --dry-run

# Remove all components (with confirmation prompts)
./scripts/uninstall.sh

# Force remove MCP configurations
./scripts/uninstall.sh --force mcp
```

## Environment Variables

You can customize installation paths by setting these environment variables:

- `CLAUDE_CONFIG_DIR` - Claude configuration directory (default: `~/.config/claude`)
- `COPILOT_CONFIG_DIR` - GitHub Copilot configuration directory (default: `~/.config/github-copilot`)
- `MCP_CONFIG_DIR` - MCP configuration directory (default: `~/.config/mcp`)
- `TOOLS_DIR` - Tools installation directory (default: `~/.local/share/ai-tools`)
- `MODES_DIR` - Modes configuration directory (default: `~/.config/ai-modes`)

**Example:**
```bash
CLAUDE_CONFIG_DIR=/custom/path ./scripts/install.sh agents
```

## Workflow

1. **Add customizations** to the appropriate directories in this repository
2. **Test locally** using the dry-run option
3. **Install** using the install script
4. **Commit changes** to the repository for version control
5. **Update** by pulling the latest changes and running install again
6. **Share** your repository to sync across multiple machines
