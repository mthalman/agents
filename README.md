# AI Agent Customizations

A structured repository for storing and managing customizations for various AI agent-related tools including Claude, GitHub Copilot, and other AI assistants.

## Overview

This repository provides a scaffolding system to organize and deploy:
- **Agents** - Custom agent configurations and definitions
- **Prompts** - System prompts, user prompts, and reusable templates
- **MCP** - Model Context Protocol server and client configurations
- **Tools** - Scripts, plugins, and integrations
- **Modes** - Operating modes and presets for different workflows

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
├── agents/              # Custom AI agent configurations (unified format)
│   └── *.md            # Agent definitions that work with both Claude & Copilot
├── prompts/            # Prompt templates and collections
│   ├── system/         # System-level prompts
│   ├── user/           # User prompts
│   └── templates/      # Reusable prompt templates
├── mcp/                # Model Context Protocol configurations
│   ├── servers/        # MCP server configurations
│   ├── clients/        # MCP client configurations
│   └── custom/         # Custom MCP implementations
├── tools/              # Tools and integrations
│   ├── scripts/        # PowerShell utility scripts
│   ├── plugins/        # Plugin configurations
│   └── integrations/   # Third-party integrations
├── modes/              # Operating modes and presets
│   ├── profiles/       # Complete configuration profiles
│   ├── presets/        # Quick-switch presets
│   └── contexts/       # Context-specific configurations
└── scripts/            # Management scripts (PowerShell)
    ├── install.ps1      # Installation script
    ├── uninstall.ps1    # Uninstallation script
    ├── new.ps1          # Template generator
    └── transform-*.ps1  # Format transformation scripts
```

### Unified Agent Format

Agents are stored in a **single, unified format** that works across multiple tools. During installation, the scripts automatically transform and deploy them to:
- **Claude Code CLI** (`~\.claude\agents\`)
- **GitHub Copilot** (`%APPDATA%\GitHub Copilot\agents\`)

This means you maintain one definition per agent, and it works with both tools.

## Installation

The installation script deploys your customizations to appropriate system locations:

```powershell
# Install all components
.\scripts\install.ps1

# Install specific components
.\scripts\install.ps1 -Component agents,prompts

# Create backups before overwriting
.\scripts\install.ps1 -Backup

# See what would be installed without making changes
.\scripts\install.ps1 -DryRun
```

### Default Installation Paths

- Claude: `~\.claude\`
- GitHub Copilot: `%APPDATA%\GitHub Copilot\`
- MCP: `~\.config\mcp\`
- Tools: `%LOCALAPPDATA%\ai-tools\`
- Modes: `~\.config\ai-modes\`

You can customize these paths using environment variables (see [scripts/README.md](scripts/README.md)).

## Usage Examples

### Adding a Custom Agent

1. Create a new file in `agents/my-agent.md` (or use the template generator)
   ```powershell
   .\scripts\new.ps1 -Type agent -Name my-agent
   ```
2. Define your agent's instructions and capabilities
3. Run `.\scripts\install.ps1 -Component agents` to deploy
4. The agent will be automatically transformed and installed for both Claude Code CLI and GitHub Copilot

### Creating a Prompt Template

1. Add a new file in `prompts/templates/my-template.md`
   ```powershell
   .\scripts\new.ps1 -Type prompt -Name my-template
   ```
2. Include metadata (tool, purpose, tags) in comments
3. Write your prompt template
4. Run `.\scripts\install.ps1 -Component prompts` to deploy

### Setting Up MCP Servers

1. Create a configuration file in `mcp/servers/my-server.json`
   ```powershell
   .\scripts\new.ps1 -Type mcp-server -Name my-server
   ```
2. Define the server command and environment variables
3. Run `.\scripts\install.ps1 -Component mcp` to deploy
4. Restart your AI tools to load the new server

### Adding Utility Scripts

1. Place your PowerShell script in `tools/scripts/my-script.ps1`
   ```powershell
   .\scripts\new.ps1 -Type tool-script -Name my-script
   ```
2. Write your script logic
3. Run `.\scripts\install.ps1 -Component tools` to deploy
4. Access from `%LOCALAPPDATA%\ai-tools\scripts\`

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

- `agents/custom/example-code-review-agent.md` - Example custom agent
- `prompts/templates/code-documentation.md` - Example prompt template
- `mcp/servers/example-mcp-config.json` - Example MCP server configuration
- `tools/scripts/git-status-overview.sh` - Example utility script
- `modes/profiles/development-mode.md` - Example mode configuration

## Documentation

Each directory contains a `README.md` with detailed information:

- [agents/README.md](agents/README.md) - Agent configurations
- [prompts/README.md](prompts/README.md) - Prompt organization
- [mcp/README.md](mcp/README.md) - MCP setup
- [tools/README.md](tools/README.md) - Tools and integrations
- [modes/README.md](modes/README.md) - Operating modes
- [scripts/README.md](scripts/README.md) - Script usage

## License

This is a personal configuration repository. Customize as needed for your own use.