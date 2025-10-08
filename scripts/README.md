# Scripts

This directory contains PowerShell scripts for managing AI agent customizations.

## Available Scripts

### new.ps1

Quickly create new customization files from templates.

**Usage:**
```powershell
.\scripts\new.ps1 -Type <type> -Name <name>
```

**Types:**
- `agent` - Create a new custom agent
- `prompt` - Create a new prompt template
- `mcp-server` - Create a new MCP server configuration
- `tool-script` - Create a new tool script (PowerShell)
- `mode-profile` - Create a new mode profile

**Examples:**
```powershell
# Create a new custom agent
.\scripts\new.ps1 -Type agent -Name my-code-reviewer

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

The installation scripts automatically transform agents from the unified format to each tool's specific requirements:

1. **Source** - Single markdown file in `agents/` directory
2. **Transform** - Automatic conversion during installation
3. **Deploy** - Installed to both Claude Code CLI and GitHub Copilot

This means you only need to maintain one version of each agent, and it will work with both tools.

## Workflow

1. **Add customizations** to the appropriate directories in this repository
2. **Test locally** using the `-DryRun` parameter
3. **Install** using the install script
4. **Commit changes** to the repository for version control
5. **Update** by pulling the latest changes and running install again
6. **Share** your repository to sync across multiple machines
