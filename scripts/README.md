# Scripts

This directory contains PowerShell scripts for managing AI agent customizations.

## Available Scripts

### new.ps1

Quickly create new customization files from templates.

**Usage:**
```powershell
# Create tool-specific customization
.\scripts\new.ps1 -Type <type> -Name <name> -Tool <tool>

# Create common customization (shared across tools)
.\scripts\new.ps1 -Type <type> -Name <name> -Common
```

**How it Works:**

The script uses `.template.md` files located in each component directory. These templates contain placeholders that are automatically replaced:
- `{{NAME}}` - Replaced with the customization name you provide
- `{{DATE}}` - Replaced with the current date (YYYY-MM-DD format)

**Template Locations:**
- `claude/agents/.template.md`
- `claude/commands/.template.md`
- `claude/output-styles/.template.md`
- `copilot/modes/.template.md`
- `copilot/prompts/.template.md`
- `common/agents/.template.md`

You can customize these templates to match your preferences or organizational standards.

**Types (depend on target tool):**

For Claude (`-Tool claude`):
- `agents` - Custom agents for Claude
- `commands` - Custom commands for Claude
- `output-styles` - Custom output formatting styles

For Copilot (`-Tool copilot`):
- `modes` - Mode profiles for GitHub Copilot
- `prompts` - Prompt templates for GitHub Copilot

For Common (`-Common` switch):
- `agents` - Agents shared between Claude and Copilot
- `commands` - Commands (if supported by both)
- `output-styles` - Output styles (if supported by both)
- `modes` - Mode profiles (if supported by both)
- `prompts` - Prompts (if supported by both)

**Examples:**
```powershell
# Create a Claude-specific agent
.\scripts\new.ps1 -Type agents -Name my-code-reviewer -Tool claude

# Create a common agent (works with both Claude and Copilot)
.\scripts\new.ps1 -Type agents -Name security-reviewer -Common

# Create a Copilot mode profile
.\scripts\new.ps1 -Type modes -Name development-mode -Tool copilot

# Create a Copilot prompt template
.\scripts\new.ps1 -Type prompts -Name git-commit-message -Tool copilot

# Create a Claude command
.\scripts\new.ps1 -Type commands -Name review-code -Tool claude
```

### install.ps1

Installs customizations from this repository to your system.

**Usage:**
```powershell
.\scripts\install.ps1 [OPTIONS] [-Tool <tool>]
```

**Parameters:**
- `-DryRun` - Show what would be installed without making changes
- `-Force` - Overwrite existing files
- `-Backup` - Create backups before overwriting
- `-Verbose` - Enable verbose output
- `-Tool` - Specific tools to install: `all`, `claude`, `copilot` (default: `all`)

**Examples:**
```powershell
# Dry run to preview changes
.\scripts\install.ps1 -DryRun

# Install all tools (Claude + Copilot)
.\scripts\install.ps1

# Install only Claude customizations
.\scripts\install.ps1 -Tool claude

# Install only Copilot customizations
.\scripts\install.ps1 -Tool copilot

# Install with backup and force overwrite
.\scripts\install.ps1 -Backup -Force -Tool all
```

### Include Processing

The installation script automatically processes include directives:

- **Include syntax**: `{{include:common/path/to/file}}` in any text file
- **Dynamic resolution**: Common content is included at installation time
- **Supported formats**: `.md`, `.txt`, `.json`, `.yaml`, `.yml` files

## Environment Variables

You can customize installation paths by setting these environment variables:

**Claude:**
- `CLAUDE_CONFIG_DIR` - Claude configuration directory (default: `~/.claude`)

**Copilot:**
- `COPILOT_CONFIG_DIR` - Copilot configuration directory (default: Windows: `%APPDATA%\Code\User`, Unix: `~/.config/github-copilot`)

**Shared/Common:**
- `MCP_CONFIG_DIR` - MCP configuration directory (default: `~/.config/mcp`)
- `TOOLS_DIR` - Tools installation directory (default: Windows: `%LOCALAPPDATA%\ai-tools`, Unix: `~/.local/share/ai-tools`)
- `MODES_DIR` - Modes configuration directory (default: `~/.config/ai-modes`)
- `PROMPTS_DIR` - Prompts directory (default: `~/.config/ai-prompts`)

**Example:**
```powershell
$env:CLAUDE_CONFIG_DIR = "C:\custom\claude"
.\scripts\install.ps1 -Tool claude
```

## Tool-Based Organization with Include System

The installation scripts support both common and tool-specific content:

1. **Common content** (in `common/` directories) - Content that can be shared between tools
2. **Tool-specific content** (in `claude/` or `copilot/` directories) - Content specific to each tool
3. **Include templating** - Use `{{include:common/path/to/file}}` to include shared content

During installation, the scripts:
- Process include directives and resolve common content references
- Deploy common content to both tools when referenced
- Deploy tool-specific content only to their respective tools
- Generate final files with includes resolved

This flexible approach allows you to:
- Share common content between tools (reduce duplication)
- Create tool-specific versions when you need advanced features
- Mix common and tool-specific content as needed
- Maintain content modularity through includes

## Customizing Templates

Each component directory contains a `.template.md` file that defines the structure for new customizations of that type. You can customize these templates to match your team's standards or preferences.

**Template Placeholders:**
- `{{NAME}}` - Replaced with the customization name
- `{{DATE}}` - Replaced with creation date (YYYY-MM-DD)

**Example - Customizing the Claude Agent Template:**

1. Edit `claude/agents/.template.md`
2. Add your organization's standard sections or guidelines
3. Use the `new.ps1` script - all new agents will use your customized template

**Creating Templates for New Component Types:**

If you add a new component directory (e.g., `claude/workflows/`):
1. Create the directory: `claude/workflows/`
2. Add a `.template.md` file with placeholders
3. The `new.ps1` script will automatically discover and use it

**Note:** Template files (`.template.md`) are excluded from installation and are only used during creation of new customizations.

## Workflow

1. **Add customizations** to the appropriate directories in this repository
2. **Test locally** using the `-DryRun` parameter
3. **Install** using the install script
4. **Commit changes** to the repository for version control
5. **Update** by pulling the latest changes and running install again
6. **Share** your repository to sync across multiple machines
