# AI Agent Customizations

A structured repository for storing and managing customizations for various AI agent-related tools including Claude, GitHub Copilot, and other AI assistants.

## Overview

This repository provides a scaffolding system organized by tool type to deploy:
- **Claude** - Claude and Claude Code CLI specific customizations
- **Copilot** - GitHub Copilot specific customizations  
- **Common** - Shared content that can be included in tool-specific files
- **Scripts** - Management and deployment scripts

## Quick Start

1. **Clone this repository:**
   ```powershell
   git clone <your-repo-url>
   cd agents
   ```

2. **Add your customizations** to the appropriate directories (see structure below)

3. **Preview installation:**
   ```powershell
   .\scripts\install.ps1 -DryRun
   ```

4. **Install to your system:**
   ```powershell
   .\scripts\install.ps1
   ```

## Repository Structure

```
agents/
├── claude/             # Claude and Claude Code CLI customizations
│   ├── agents/         # Claude-specific agent configurations
│   ├── prompts/        # Claude-specific prompts
│   ├── mcp/           # Claude-specific MCP configurations
│   ├── tools/         # Claude-specific tools and scripts
│   └── modes/         # Claude-specific operating modes
├── copilot/           # GitHub Copilot customizations
│   ├── agents/        # Copilot-specific agent configurations
│   ├── prompts/       # Copilot-specific prompts
│   ├── mcp/          # Copilot-specific MCP configurations
│   ├── tools/        # Copilot-specific tools and scripts
│   └── modes/        # Copilot-specific operating modes
├── common/           # Shared content (can be included via templating)
│   ├── agents/       # Common agent instructions and behaviors
│   ├── prompts/      # Reusable prompt templates and sections
│   ├── mcp/         # Shared MCP server configurations
│   ├── tools/       # Common utility scripts and configurations
│   └── modes/       # Shared mode settings and profiles
└── scripts/         # Management scripts (PowerShell)
    ├── install.ps1   # Installation script with include processing
    ├── uninstall.ps1 # Uninstallation script
    └── new.ps1       # Template generator
```

### Tool-Based Organization with Include System

- **Tool-specific directories** (`claude/`, `copilot/`): Contains customizations specific to each tool
- **Common directory** (`common/`): Contains shared content that can be included in tool-specific files
- **Include templating**: Use `{{include:common/path/to/file}}` to include common content

The installation script automatically:
- Processes include directives in tool-specific files
- Deploys common content to both tools when referenced
- Deploys tool-specific files only to their respective tools
- Resolves includes at installation time for dynamic content sharing

## Installation

The installation script deploys your customizations to appropriate system locations:

```powershell
# Install all tools (common + Claude + Copilot)
.\scripts\install.ps1

# Install specific tools
.\scripts\install.ps1 -Tool claude      # Install common + Claude
.\scripts\install.ps1 -Tool copilot     # Install common + Copilot
.\scripts\install.ps1 -Tool common      # Install only common content to both tools

# Create backups before overwriting
.\scripts\install.ps1 -Backup

# See what would be installed without making changes
.\scripts\install.ps1 -DryRun
```

### Default Installation Paths

- Claude: `~\.claude\`
- VS Code GitHub Copilot: `%APPDATA%\Code\User`

You can customize these paths using environment variables (see [scripts/README.md](scripts/README.md)).

## Usage Examples

### Adding a Custom Agent

1. Create a new file (or use the template generator)
   ```powershell
   # Create a common agent (works with both tools)
   .\scripts\new.ps1 -Type agent -Name my-agent
   
   # Create a Claude-specific agent
   .\scripts\new.ps1 -Type agent -Name my-claude-agent -Tool claude
   
   # Create a Copilot-specific agent
   .\scripts\new.ps1 -Type agent -Name my-copilot-agent -Tool copilot
   ```
2. Define your agent's instructions and capabilities:
   ```markdown
   ---
   name: my-agent
   description: Brief description
   ---
   
   Agent instructions here...
   
   {{include:common/agents/security-guidelines.md}}
   
   Tool-specific instructions...
   ```
3. Run `.\scripts\install.ps1 -Tool claude` to deploy (or `-Tool copilot` for Copilot)
4. Common agents are installed to both Claude and Copilot
5. Tool-specific agents are installed only to their respective tools
6. Include directives are resolved during installation

### Creating a Prompt Template

1. Add a new file in the common directory (or tool-specific directory)
   ```powershell
   .\scripts\new.ps1 -Type prompt -Name my-template
   ```
2. Include metadata (tool, purpose, tags) in comments
3. Write your prompt template with optional includes:
   ```markdown
   # My Template
   
   {{include:common/prompts/standard-instructions.md}}
   
   Specific instructions for this template...
   ```
4. Run `.\scripts\install.ps1 -Tool all` to deploy

### Setting Up MCP Servers

1. Create a configuration file in the common or tool-specific directory
   ```powershell
   .\scripts\new.ps1 -Type mcp-server -Name my-server
   ```
2. Define the server command and environment variables
3. Run `.\scripts\install.ps1 -Tool all` to deploy
4. Common MCP configs are deployed to both tools
5. Restart your AI tools to load the new server

### Adding Utility Scripts

1. Place your PowerShell script in the common or tool-specific directory
   ```powershell
   .\scripts\new.ps1 -Type tool-script -Name my-script
   ```
2. Write your script logic with optional includes for common functions
3. Run `.\scripts\install.ps1 -Tool all` to deploy
4. Access from `%LOCALAPPDATA%\ai-tools\` (common tools in root, tool-specific in subdirectories)

## Syncing Across Machines

This repository is designed to be version-controlled and shared:

1. **Commit your customizations:**
   ```powershell
   git add .
   git commit -m "Add my customizations"
   git push
   ```

2. **On another machine:**
   ```powershell
   git clone <your-repo-url>
   cd agents
   .\scripts\install.ps1
   ```

3. **Update existing installations:**
   ```powershell
   git pull
   .\scripts\install.ps1 -Force
   ```

## Customizing Templates

The `new.ps1` script uses `.template.md` files to create new customizations. Each component directory contains a template file that you can customize to match your organization's standards.

### Template Locations

- `claude/agents/.template.md` - Template for Claude agents
- `claude/commands/.template.md` - Template for Claude commands  
- `claude/output-styles/.template.md` - Template for Claude output styles
- `copilot/modes/.template.md` - Template for Copilot mode profiles
- `copilot/prompts/.template.md` - Template for Copilot prompts
- `common/agents/.template.md` - Template for common agents

### Template Placeholders

Templates support the following placeholders that are automatically replaced:

- `{{NAME}}` - Replaced with the customization name you provide
- `{{DATE}}` - Replaced with the current date (YYYY-MM-DD format)

### Example: Customizing the Claude Agent Template

1. Open `claude/agents/.template.md`
2. Edit the content to match your team's standards:
   ```markdown
   ---
   name: {{NAME}}
   description: [Brief description]
   ---
   
   # {{NAME}} Agent
   
   **Created**: {{DATE}}
   **Team**: Your Team Name
   
   [Your standard sections here...]
   ```

3. Save the file
4. Create a new agent - it will use your customized template:
   ```powershell
   .\scripts\new.ps1 -Type agents -Name my-agent -Tool claude
   ```

### Adding New Component Types

If you create a new component directory, add a `.template.md` file and the `new.ps1` script will automatically use it:

1. Create the directory (e.g., `claude/workflows/`)
2. Create `.template.md` in that directory with `{{NAME}}` and `{{DATE}}` placeholders
3. Run `new.ps1` - it will discover your new component type automatically

**Note**: Template files (`.template.md`) are excluded from installation automatically.

## Security Considerations

- **Never commit sensitive data** (API keys, tokens, credentials)
- Use `.gitignore` to exclude sensitive files
- Store secrets in environment variables or secure vaults
- Review the `.gitignore` file to ensure sensitive patterns are excluded

## Uninstallation

To remove installed customizations:

```powershell
# Remove all components (with confirmation)
.\scripts\uninstall.ps1

# Remove specific components
.\scripts\uninstall.ps1 -Component mcp,tools

# Force remove without confirmation
.\scripts\uninstall.ps1 -Force
```

## Contributing

This is a personal customization repository, but you can:

1. Fork for your own use
2. Share interesting agents, prompts, or tools
3. Suggest improvements to the scaffolding structure

## Examples

The repository includes example files to help you get started:

- `common/agents/example-code-review-agent.md` - Example common agent
- `common/prompts/code-documentation.md` - Example prompt template
- `common/mcp/example-mcp-config.json` - Example MCP server configuration
- `common/tools/git-status-overview.ps1` - Example utility script
- `common/modes/development-mode.md` - Example mode configuration

## Documentation

Each directory contains a `README.md` with detailed information:

- [claude/README.md](claude/README.md) - Claude-specific customizations
- [copilot/README.md](copilot/README.md) - Copilot-specific customizations
- [common/README.md](common/README.md) - Common content and include system
- [scripts/README.md](scripts/README.md) - Script usage and management

## License

This is a personal configuration repository. Customize as needed for your own use.