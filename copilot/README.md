# GitHub Copilot Customizations

This directory contains customizations specific to [VS Code GitHub Copilot](https://code.visualstudio.com/docs/copilot/overview).

## Structure

- **modes/** - [Copilot chat modes](https://code.visualstudio.com/docs/copilot/chat/chat-modes#_custom-chat-modes)
- **prompts/** - [Copilot prompts](https://code.visualstudio.com/docs/copilot/customization/prompt-files)

## Include System

You can reference common content using the include syntax:
```
{{include:common/path/to/file}}
```

This allows you to share content between different tools while still having tool-specific customizations.

## Usage

Files in this directory will be processed during installation and deployed to:
- `%APPDATA%\Code\User` (or your configured VS Code profile directory)
