# Quick Start Guide

Get up and running with AI Agent Customizations in 5 minutes.

## Prerequisites

- PowerShell 5.1 or later (included with Windows 10+)
- Git installed
- One or more AI tools (Claude Code CLI, GitHub Copilot, etc.)

## Step 1: Clone the Repository

```powershell
git clone <your-repo-url>
cd agents
```

## Step 2: Explore the Structure

```powershell
# View the directory structure
Get-ChildItem

# Read the main README
Get-Content README.md

# Check out example files
Get-Content agents\example-code-review-agent.md
Get-Content prompts\templates\code-documentation.md
```

## Step 3: Add Your First Customization

Let's create a simple custom prompt:

```powershell
# Create a new prompt file using the template generator
.\scripts\new.ps1 -Type prompt -Name explain-code
```

Then edit `prompts\templates\explain-code.md` with your content.

## Step 4: Preview Installation

```powershell
# See what would be installed without making changes
.\scripts\install.ps1 -DryRun
```

## Step 5: Install Your Customizations

```powershell
# Install all components
.\scripts\install.ps1

# Or install only prompts
.\scripts\install.ps1 -Component prompts
```

## Step 6: Verify Installation

```powershell
# Check that files were copied
Get-ChildItem ~\.config\ai-prompts\templates\

# View the installed file
Get-Content ~\.config\ai-prompts\templates\explain-code.md
```

## Step 7: Use Your Customization

In your AI tool:
1. Reference the installed prompt
2. Or copy the content when needed
3. Modify and iterate as you use it

## Step 8: Update and Commit

```powershell
# Add your changes
git add prompts\templates\explain-code.md

# Commit
git commit -m "Add code explainer prompt"

# Push to share across machines
git push
```

## Next Steps

### Add More Customizations

```powershell
# Create a custom agent (unified format works with both Claude & Copilot)
.\scripts\new.ps1 -Type agent -Name my-agent

# Add an MCP server configuration
.\scripts\new.ps1 -Type mcp-server -Name my-server

# Create a utility script
.\scripts\new.ps1 -Type tool-script -Name my-script
```

### Sync to Another Machine

```powershell
# On another machine
git clone <your-repo-url>
cd agents
.\scripts\install.ps1 -Force
```

### Update Existing Installations

```powershell
# Make changes in the repository
# Edit files as needed

# Pull latest changes (if on another machine)
git pull

# Reinstall (force overwrite)
.\scripts\install.ps1 -Force -Component prompts
```

### Create a Development Mode

```powershell
# Use the template generator
.\scripts\new.ps1 -Type mode-profile -Name my-dev-mode

# Edit the file
notepad modes\profiles\my-dev-mode.md

# Install
.\scripts\install.ps1 -Component modes
```

## Tips

1. **Use -DryRun first** to preview changes
2. **Use -Backup** when overwriting existing files
3. **Keep sensitive data out** of the repository
4. **Unified agent format** - One agent definition works with both Claude and Copilot
5. **Use template generator** - `.\scripts\new.ps1` creates properly formatted files

## Common Tasks

### Install with Backup
```powershell
.\scripts\install.ps1 -Backup
```

### Install Specific Components
```powershell
.\scripts\install.ps1 -Component agents,mcp
```

### Verbose Installation
```powershell
.\scripts\install.ps1 -Verbose
```

### Uninstall Everything
```powershell
.\scripts\uninstall.ps1
```

### Custom Installation Path
```powershell
$env:TOOLS_DIR = "C:\custom\path"
.\scripts\install.ps1 -Component tools
```

## Troubleshooting

### Scripts Won't Run
```powershell
# Check execution policy
Get-ExecutionPolicy

# If needed, set execution policy (run as Administrator)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Files Not Installing
```powershell
# Check source files exist
Get-ChildItem agents\
Get-ChildItem prompts\templates\

# Run with verbose output
.\scripts\install.ps1 -Verbose
```

### Wrong Installation Path
```powershell
# Use environment variables
$env:CLAUDE_CONFIG_DIR = "C:\path\to\claude"
.\scripts\install.ps1 -Component agents
```

## Getting Help

- Read the main [README.md](README.md)
- Check directory-specific READMEs
- Review example files
- Run `./scripts/install.sh --help`

## What's Next?

- Explore the example files in each directory
- Read the detailed documentation in each section's README
- Customize the scaffolding for your workflow
- Share useful agents, prompts, and tools with others (via separate repos)
