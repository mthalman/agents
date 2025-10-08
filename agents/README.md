# Agents

This directory contains custom AI agent configurations in a unified format that works across multiple tools.

## Unified Format

All agents are stored in a single, tool-agnostic markdown format. The installation scripts automatically transform and deploy them to:
- **Claude Code CLI** - Installed to `~/.claude/agents/`
- **GitHub Copilot** - Installed to `%APPDATA%/GitHub Copilot/agents/`

This approach allows you to maintain one set of agent definitions that work with both tools.

## Agent File Format

Agent files are written in markdown and typically include:
- Agent name and description
- Capabilities and constraints
- Custom instructions
- Examples and notes

### Example Structure

```markdown
# Custom Agent: [Name]

## Agent Metadata
- **Name**: [Agent name]
- **Purpose**: [Brief description]

## Instructions
[Detailed instructions for the agent]

## Examples
[Usage examples]
```

## Usage

1. Create agent files in this directory (or use `scripts\new.ps1 -Type agent -Name your-agent`)
2. Run `scripts\install.ps1` to deploy to all configured tools
3. The installation script will automatically transform the unified format to each tool's requirements

## Benefits

- **Single source of truth** - Maintain one definition for all tools
- **Consistency** - Same behavior across different AI assistants
- **Easy maintenance** - Update once, deploy everywhere
