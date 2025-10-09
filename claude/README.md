# Claude Customizations

This directory contains customizations specific to [Claude Code CLI](https://docs.claude.com/en/docs/claude-code/overview).

## Structure

- **agents/** - [agent definitions](https://docs.claude.com/en/docs/claude-code/sub-agents)
- **commands/** - [command definitions](https://docs.claude.com/en/docs/claude-code/slash-commands#custom-slash-commands)
- **output-styles/** - [output style definitions](https://docs.claude.com/en/docs/claude-code/output-styles)

## Include System

You can reference common content using the include syntax:
```
{{include:common/path/to/file}}
```

This allows you to share content between different tools while still having tool-specific customizations.

## Usage

Files in this directory will be processed during [installation](../README.md#installation) and deployed to:
- `~\.claude\` (or your configured Claude directory)
