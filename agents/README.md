# Agents

This directory contains custom AI agent configurations that support both unified (tool-agnostic) and tool-specific formats.

## Directory Structure

```
agents/
├── README.md               # This file
├── *.md                    # Unified agent definitions (work across tools)
├── claude/                 # Claude Code CLI specific agents
│   └── *.md               # Claude-specific agent files
└── copilot/               # GitHub Copilot specific agents
    └── *.md               # Copilot-specific agent files
```

## Unified Format (Recommended)

Place agent files directly in the `agents/` directory for automatic deployment to both Claude Code CLI and GitHub Copilot. These files use a format compatible with both tools.

### Example Unified Agent

```markdown
---
name: agent-name
description: Brief description of the agent
---

Your agent instructions here...
```

The installation script automatically transforms and deploys unified agents to:
- **Claude Code CLI** - Installed to `~/.claude/agents/`
- **GitHub Copilot** - Installed to `%APPDATA%/GitHub Copilot/agents/`

## Tool-Specific Format

For cases where you need tool-specific behavior, place files in the appropriate subdirectory:

- **`claude/`** - Files using Claude Code CLI specific features or format
- **`copilot/`** - Files using GitHub Copilot specific features or format

Tool-specific files take precedence over unified files when both exist for the same agent.

## Agent File Format

### Claude Code CLI Format

Claude Code CLI sub-agents use YAML frontmatter:

```markdown
---
name: agent-name
description: Brief description
---

Agent instructions and behavior...
```

### GitHub Copilot Format

GitHub Copilot agents use markdown format (same as unified):

```markdown
---
name: agent-name
description: Brief description
---

Agent instructions...
```

## Usage

1. **Create agent files** in this directory (or use `scripts\new.ps1 -Type agent -Name your-agent`)
   - Use the root `agents/` directory for unified agents
   - Use `agents/claude/` or `agents/copilot/` for tool-specific agents
2. **Run `scripts\install.ps1`** to deploy to all configured tools
3. The installation script will:
   - Deploy unified agents to both tools
   - Deploy tool-specific agents to their respective tools
   - Transform formats as needed

## Benefits

- **Unified agents**: Maintain one definition for all tools - consistent behavior
- **Tool-specific agents**: Use advanced features specific to each tool
- **Flexible**: Mix and match as needed for your workflow
- **Easy maintenance**: Update once, deploy everywhere (for unified agents)
