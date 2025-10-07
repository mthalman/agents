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
   ```bash
   git clone <your-repo-url>
   cd agents
   ```

2. **Add your customizations** to the appropriate directories (see structure below)

3. **Preview installation:**
   ```bash
   ./scripts/install.sh --dry-run
   ```

4. **Install to your system:**
   ```bash
   ./scripts/install.sh
   ```

## Repository Structure

```
agents/
├── agents/              # Custom AI agent configurations
│   ├── claude/         # Claude-specific agents
│   ├── copilot/        # GitHub Copilot agents
│   └── custom/         # Custom agent definitions
├── prompts/            # Prompt templates and collections
│   ├── system/         # System-level prompts
│   ├── user/           # User prompts
│   └── templates/      # Reusable prompt templates
├── mcp/                # Model Context Protocol configurations
│   ├── servers/        # MCP server configurations
│   ├── clients/        # MCP client configurations
│   └── custom/         # Custom MCP implementations
├── tools/              # Tools and integrations
│   ├── scripts/        # Utility scripts
│   ├── plugins/        # Plugin configurations
│   └── integrations/   # Third-party integrations
├── modes/              # Operating modes and presets
│   ├── profiles/       # Complete configuration profiles
│   ├── presets/        # Quick-switch presets
│   └── contexts/       # Context-specific configurations
└── scripts/            # Management scripts
    ├── install.sh      # Installation script
    ├── uninstall.sh    # Uninstallation script
    └── README.md       # Scripts documentation
```

## Installation

The installation script deploys your customizations to appropriate system locations:

```bash
# Install all components
./scripts/install.sh

# Install specific components
./scripts/install.sh agents prompts

# Create backups before overwriting
./scripts/install.sh --backup

# See what would be installed without making changes
./scripts/install.sh --dry-run
```

### Default Installation Paths

- Claude: `~/.config/claude/`
- GitHub Copilot: `~/.config/github-copilot/`
- MCP: `~/.config/mcp/`
- Tools: `~/.local/share/ai-tools/`
- Modes: `~/.config/ai-modes/`

You can customize these paths using environment variables (see [scripts/README.md](scripts/README.md)).

## Usage Examples

### Adding a Custom Agent

1. Create a new file in `agents/custom/my-agent.md`
2. Define your agent's instructions and capabilities
3. Run `./scripts/install.sh agents` to deploy
4. Reference the agent in your AI tool configuration

### Creating a Prompt Template

1. Add a new file in `prompts/templates/my-template.md`
2. Include metadata (tool, purpose, tags) in comments
3. Write your prompt template
4. Run `./scripts/install.sh prompts` to deploy

### Setting Up MCP Servers

1. Create a configuration file in `mcp/servers/my-server.json`
2. Define the server command and environment variables
3. Run `./scripts/install.sh mcp` to deploy
4. Restart your AI tools to load the new server

### Adding Utility Scripts

1. Place your script in `tools/scripts/my-script.sh`
2. Make it executable: `chmod +x tools/scripts/my-script.sh`
3. Run `./scripts/install.sh tools` to deploy
4. Access from `~/.local/share/ai-tools/scripts/`

## Syncing Across Machines

This repository is designed to be version-controlled and shared:

1. **Commit your customizations:**
   ```bash
   git add .
   git commit -m "Add my customizations"
   git push
   ```

2. **On another machine:**
   ```bash
   git clone <your-repo-url>
   cd agents
   ./scripts/install.sh
   ```

3. **Update existing installations:**
   ```bash
   git pull
   ./scripts/install.sh --force
   ```

## Security Considerations

- **Never commit sensitive data** (API keys, tokens, credentials)
- Use `.gitignore` to exclude sensitive files
- Store secrets in environment variables or secure vaults
- Review the `.gitignore` file to ensure sensitive patterns are excluded

## Uninstallation

To remove installed customizations:

```bash
# Remove all components (with confirmation)
./scripts/uninstall.sh

# Remove specific components
./scripts/uninstall.sh mcp tools

# Force remove without confirmation
./scripts/uninstall.sh --force
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