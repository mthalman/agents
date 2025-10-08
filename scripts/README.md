# Scripts

This directory contains PowerShell scripts for managing AI agent customizations.

## Available Scripts

### new.ps1

Quickly create new customization files from templates.

**Usage:**
```powershell
.\scripts\new.ps1 -Type <type> -Name <name> [-Tool <tool>]
```

**Types:**
- `agent` - Create a new custom agent
- `prompt` - Create a new prompt template
- `mcp-server` - Create a new MCP server configuration
- `tool-script` - Create a new tool script (PowerShell)
- `mode-profile` - Create a new mode profile

**Tool (for agents only):**
- `unified` (default) - Create a unified agent that works with both Claude and Copilot
- `claude` - Create a Claude Code CLI specific agent
- `copilot` - Create a GitHub Copilot specific agent

**Examples:**
```powershell
# Create a unified agent (works with both tools)
.\scripts\new.ps1 -Type agent -Name my-code-reviewer

# Create a Claude-specific agent
.\scripts\new.ps1 -Type agent -Name my-claude-agent -Tool claude

# Create a Copilot-specific agent
.\scripts\new.ps1 -Type agent -Name my-copilot-agent -Tool copilot

# Create a new prompt template
.\scripts\new.ps1 -Type prompt -Name git-commit-message

# Create a new tool script
.\scripts\new.ps1 -Type tool-script -Name backup-configs
```

### install.ps1

Installs customizations from this repository to your system.

**Usage:**
```powershell
.\scripts\install.ps1 [OPTIONS] [-Component <components>]
```

**Parameters:**
- `-DryRun` - Show what would be installed without making changes
- `-Force` - Overwrite existing files
- `-Backup` - Create backups before overwriting
- `-Verbose` - Enable verbose output
- `-Component` - Specific components to install (all, agents, prompts, mcp, tools, modes)

**Examples:**
```powershell
# Dry run to preview changes
.\scripts\install.ps1 -DryRun

# Install all components
.\scripts\install.ps1

# Install only MCP configurations with backup
.\scripts\install.ps1 -Backup -Component mcp

# Install agents and prompts, forcing overwrite
.\scripts\install.ps1 -Force -Component agents,prompts
```

### uninstall.ps1

Removes installed customizations from your system.

**Usage:**
```powershell
.\scripts\uninstall.ps1 [OPTIONS] [-Component <components>]
```

**Parameters:**
- `-DryRun` - Show what would be removed without making changes
- `-Force` - Remove without confirmation
- `-Verbose` - Enable verbose output
- `-Component` - Specific components to remove (all, agents, prompts, mcp, tools, modes)

**Examples:**
```powershell
# Dry run to preview what would be removed
.\scripts\uninstall.ps1 -DryRun

# Remove all components (with confirmation prompts)
.\scripts\uninstall.ps1

# Force remove MCP configurations
.\scripts\uninstall.ps1 -Force -Component mcp
```

### Transformation Scripts

These scripts are called automatically by `install.ps1`:

- **transform-for-claude.ps1** - Transforms unified agent format to Claude Code CLI format
- **transform-for-copilot.ps1** - Transforms unified agent format to GitHub Copilot format

## Environment Variables

You can customize installation paths by setting these environment variables:

- `CLAUDE_CONFIG_DIR` - Claude configuration directory (default: `~\.claude`)
- `COPILOT_CONFIG_DIR` - GitHub Copilot configuration directory (default: `%APPDATA%\GitHub Copilot`)
- `MCP_CONFIG_DIR` - MCP configuration directory (default: `~\.config\mcp`)
- `TOOLS_DIR` - Tools installation directory (default: `%LOCALAPPDATA%\ai-tools`)
- `MODES_DIR` - Modes configuration directory (default: `~\.config\ai-modes`)

**Example:**
```powershell
$env:CLAUDE_CONFIG_DIR = "C:\custom\path"
.\scripts\install.ps1 -Component agents
```

## Unified Agent Format

The installation scripts support both unified and tool-specific agents:

1. **Unified agents** (in `agents/` root) - Single markdown file that works with both Claude and Copilot
2. **Tool-specific agents** (in `agents/claude/` or `agents/copilot/`) - Use advanced features specific to each tool

During installation, the scripts:
- Transform unified agents and deploy to both Claude Code CLI and GitHub Copilot
- Deploy tool-specific agents only to their respective tools
- Tool-specific files take precedence over unified files if both exist

This flexible approach allows you to:
- Use unified format for most agents (simpler, less duplication)
- Create tool-specific versions when you need advanced features
- Mix and match as needed for your workflow

## Workflow

1. **Add customizations** to the appropriate directories in this repository
2. **Test locally** using the `-DryRun` parameter
3. **Install** using the install script
4. **Commit changes** to the repository for version control
5. **Update** by pulling the latest changes and running install again
6. **Share** your repository to sync across multiple machines
