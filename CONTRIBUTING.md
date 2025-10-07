# Contributing Guide

This is a personal customization repository, but you're welcome to fork it and adapt it for your own use.

## For Your Own Fork

### Getting Started

1. **Fork the repository** to your own GitHub account
2. **Clone your fork** locally
3. **Add your customizations** to the appropriate directories
4. **Test thoroughly** using `--dry-run` first
5. **Commit and push** to your fork

### Best Practices

#### Organization

- Keep files organized by tool/category
- Use descriptive filenames
- Include README files for complex setups
- Document your customizations

#### Security

- **Never commit secrets** (API keys, tokens, passwords)
- Review `.gitignore` before committing
- Use environment variables for sensitive data
- Consider using git-crypt for encrypted configs

#### Naming Conventions

- Use lowercase with hyphens: `my-custom-agent.md`
- Include descriptive prefixes: `code-review-agent.md`
- Group related files: `git-*.sh` for git tools

#### Documentation

- Add metadata to prompt files (tool, purpose, tags)
- Include usage examples in complex configurations
- Keep READMEs up to date
- Document any dependencies

### Testing

Before committing changes:

```bash
# Test dry-run
./scripts/install.sh --dry-run

# Test actual installation
./scripts/install.sh --verbose

# Verify files were installed correctly
ls -la ~/.config/ai-prompts/

# Test your customizations in your AI tool

# If everything works, commit
git add .
git commit -m "Add XYZ customization"
```

### Syncing Across Machines

```bash
# On Machine A - make changes and push
git add .
git commit -m "Update prompts"
git push

# On Machine B - pull and install
git pull
./scripts/install.sh --force
```

## Suggesting Improvements

If you have ideas to improve the scaffolding structure:

1. **Open an issue** describing the improvement
2. **Provide examples** of how it would work
3. **Consider backwards compatibility**
4. **Keep it simple** - this is meant to be lightweight

### Areas for Improvement

We welcome suggestions for:

- Better directory organization
- Additional installation options
- New script features
- Documentation improvements
- Example customizations
- Platform-specific guides

## Sharing Your Customizations

### What to Share

Consider creating separate repositories for:

- Collections of prompts for specific use cases
- Custom agents for particular domains
- MCP server configurations
- Utility scripts and tools

### What NOT to Share

- Proprietary company information
- API keys or tokens
- Personal data
- Copyrighted content without permission

### Sharing Format

If you create valuable customizations:

1. **Clean up** and generalize them
2. **Document** thoroughly
3. **Remove** any personal/sensitive data
4. **Create a new repository** with proper licensing
5. **Share a link** in discussions/issues

## Code Style

### Bash Scripts

- Use `#!/usr/bin/env bash` shebang
- Add `set -e` for error handling
- Include help/usage functions
- Use meaningful variable names
- Comment complex logic
- Test on multiple platforms if possible

### Markdown Files

- Use clear headings
- Include examples
- Keep lines under 100 characters when possible
- Use code blocks with syntax highlighting
- Link to related documents

### JSON/Configuration

- Use proper indentation (2 or 4 spaces)
- Include comments where the format allows
- Validate JSON before committing
- Use meaningful keys

## Extending the Scripts

### Adding New Features

If you want to extend the installation scripts:

```bash
# Fork the repository
# Edit scripts/install.sh
# Test thoroughly
# Document new options
# Consider submitting changes back
```

### Creating Additional Scripts

You can add helper scripts to `scripts/`:

- `sync.sh` - Sync with remote repository
- `validate.sh` - Validate configurations
- `template.sh` - Generate template files
- `backup.sh` - Backup current configurations

## Version Control

### Commit Messages

Use clear, descriptive commit messages:

```
✓ Good:
  - Add GitHub API integration prompt
  - Update installation script with backup option
  - Fix MCP server configuration example

✗ Bad:
  - Update files
  - Fix stuff
  - Changes
```

### Branching

For your fork:

```bash
# Create feature branches for major changes
git checkout -b add-terraform-tools

# Make changes, test, commit

# Merge back to main
git checkout main
git merge add-terraform-tools
```

## Getting Help

- Review existing examples in the repository
- Check documentation in directory READMEs
- Read the Quick Start guide
- Open an issue for questions

## License

This is a personal configuration repository. When forking:

- You can use and modify freely for personal use
- Consider adding your own license
- Respect licenses of any included third-party content

## Acknowledgments

If you create something based on this scaffolding:

- Feel free to link back to the original repository
- Share improvements that could benefit others
- Credit any sources of inspiration

---

Remember: This is **your** customization repository. Adapt it to fit your workflow and needs!
