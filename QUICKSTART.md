# Quick Start Guide

Get up and running with AI Agent Customizations in 5 minutes.

## Prerequisites

- Bash shell (Linux, macOS, or WSL on Windows)
- Git installed
- One or more AI tools (Claude, GitHub Copilot, etc.)

## Step 1: Clone the Repository

```bash
git clone <your-repo-url>
cd agents
```

## Step 2: Explore the Structure

```bash
# View the directory structure
ls -la

# Read the main README
cat README.md

# Check out example files
cat agents/custom/example-code-review-agent.md
cat prompts/templates/code-documentation.md
```

## Step 3: Add Your First Customization

Let's create a simple custom prompt:

```bash
# Create a new prompt file
cat > prompts/user/explain-code.md << 'EOF'
# Prompt: Code Explainer
# Tool: Universal
# Purpose: Explain code in simple terms
# Tags: learning, education, code

Please explain the following code in simple terms:
1. What does it do?
2. How does it work?
3. Are there any potential issues?
4. How could it be improved?

Keep your explanation clear and accessible.
EOF
```

## Step 4: Preview Installation

```bash
# See what would be installed without making changes
./scripts/install.sh --dry-run
```

## Step 5: Install Your Customizations

```bash
# Install all components
./scripts/install.sh

# Or install only prompts
./scripts/install.sh prompts
```

## Step 6: Verify Installation

```bash
# Check that files were copied
ls ~/.config/ai-prompts/user/

# View the installed file
cat ~/.config/ai-prompts/user/explain-code.md
```

## Step 7: Use Your Customization

In your AI tool:
1. Reference the installed prompt
2. Or copy the content when needed
3. Modify and iterate as you use it

## Step 8: Update and Commit

```bash
# Add your changes
git add prompts/user/explain-code.md

# Commit
git commit -m "Add code explainer prompt"

# Push to share across machines
git push
```

## Next Steps

### Add More Customizations

```bash
# Create a custom agent
vi agents/custom/my-agent.md

# Add an MCP server configuration
vi mcp/servers/my-server.json

# Create a utility script
vi tools/scripts/my-script.sh
chmod +x tools/scripts/my-script.sh
```

### Sync to Another Machine

```bash
# On another machine
git clone <your-repo-url>
cd agents
./scripts/install.sh --force
```

### Update Existing Installations

```bash
# Make changes in the repository
vi prompts/user/explain-code.md

# Pull latest changes (if on another machine)
git pull

# Reinstall (force overwrite)
./scripts/install.sh --force prompts
```

### Create a Development Mode

```bash
# Copy the example
cp modes/profiles/development-mode.md modes/profiles/my-dev-mode.md

# Customize it
vi modes/profiles/my-dev-mode.md

# Install
./scripts/install.sh modes
```

## Tips

1. **Use --dry-run first** to preview changes
2. **Use --backup** when overwriting existing files
3. **Keep sensitive data out** of the repository
4. **Organize by tool** if you use multiple AI assistants
5. **Document your customizations** with clear descriptions

## Common Tasks

### Install with Backup
```bash
./scripts/install.sh --backup
```

### Install Specific Components
```bash
./scripts/install.sh agents mcp
```

### Verbose Installation
```bash
./scripts/install.sh --verbose
```

### Uninstall Everything
```bash
./scripts/uninstall.sh
```

### Custom Installation Path
```bash
TOOLS_DIR=/custom/path ./scripts/install.sh tools
```

## Troubleshooting

### Scripts Won't Run
```bash
# Make sure scripts are executable
chmod +x scripts/*.sh
```

### Files Not Installing
```bash
# Check source files exist
ls -la agents/custom/
ls -la prompts/user/

# Run with verbose output
./scripts/install.sh --verbose
```

### Wrong Installation Path
```bash
# Use environment variables
CLAUDE_CONFIG_DIR=/path/to/claude ./scripts/install.sh agents
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
