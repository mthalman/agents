# Testing Guide for Install Scripts

This document describes the test suite for the AI Agent Customizations installation scripts.

## Test Framework

The tests use **Pester v5**, PowerShell's BDD-style testing framework. Pester provides:
- Comprehensive test organization with `Describe`, `Context`, and `It` blocks
- Rich assertion library with `Should` commands
- Before/After hooks for setup and teardown
- Mocking capabilities for external dependencies
- Code coverage analysis

## Running Tests

### Quick Start

```powershell
# Run all tests
.\scripts\run-tests.ps1

# Run specific test file
.\scripts\run-tests.ps1 -TestPath .\scripts\install.tests.ps1

# Show only failures
.\scripts\run-tests.ps1 -Show Fails

# Generate test report
.\scripts\run-tests.ps1 -OutputFormat JUnitXml
```

### Manual Testing with Pester

```powershell
# Install Pester if needed
Install-Module -Name Pester -MinimumVersion 5.0.0 -Force -Scope CurrentUser

# Run tests directly
Invoke-Pester -Path .\scripts\install.tests.ps1

# Run with detailed output
Invoke-Pester -Path .\scripts\install.tests.ps1 -Output Detailed

# Run specific test by name
Invoke-Pester -Path .\scripts\install.tests.ps1 -FullNameFilter "*Get-ExtraFiles*"
```

## Test Structure

### Test Categories

1. **Basic Functionality**
   - Script loading and parameter validation
   - Required parameter presence
   - Valid/invalid parameter values

2. **File Detection Functions**
   - `Get-ExtraFiles`: Detecting extra files in destinations
   - `Format-FileSize`: File size formatting
   - `Process-ExtraFiles`: Extra file processing logic

3. **Installation Functions**
   - `Install-Files`: File copying logic
   - DryRun mode behavior
   - Force overwrite functionality
   - Backup creation
   - Subdirectory handling
   - File filtering (README.md, .template.md)

4. **Include File Processing**
   - `Resolve-Includes`: Processing {{include:}} directives
   - Nested includes
   - Missing file handling

5. **Extra Files Management**
   - `Show-ExtraFilesSummary`: Extra files detection and display
   - Interactive deletion prompts (when not in CI)
   - File categorization by tool

6. **Tool-Specific Installation**
   - Claude-specific installation
   - Copilot-specific installation
   - Combined 'all' tool installation

7. **Error Handling**
   - Missing source directories
   - Permission errors
   - Invalid configurations

### Test Isolation

Each test:
- Creates its own temporary directory structure in `$env:TEMP`
- Cleans up after itself in `AfterAll` blocks
- Uses mocked home directories to avoid affecting real configurations
- Isolates environment variables

### Mocking Strategy

The tests use several mocking approaches:
- **File System Mocking**: Creates temporary test directories
- **Environment Variable Mocking**: Overrides config paths
- **Function Mocking**: Mocks user interaction functions like `Read-Host`

## CI/CD Integration

### GitHub Actions

Tests run automatically on:
- Push to `main` or `develop` branches
- Pull requests to `main`
- Manual workflow dispatch

The workflow:
1. Tests on Windows (native PowerShell)
2. Tests on Linux (PowerShell Core)
3. Tests on macOS (PowerShell Core)

### Test Results

- JUnit XML reports are generated
- Test results are uploaded as artifacts
- Results are published as PR checks

## Writing New Tests

### Test Template

```powershell
Describe "Feature Name" {
    BeforeAll {
        # Setup code that runs once before all tests
    }

    AfterAll {
        # Cleanup code that runs once after all tests
    }

    BeforeEach {
        # Setup code that runs before each test
    }

    AfterEach {
        # Cleanup code that runs after each test
    }

    Context "Specific Scenario" {
        It "Should do something specific" {
            # Arrange
            $input = "test"

            # Act
            $result = Some-Function -Parameter $input

            # Assert
            $result | Should -Be "expected"
        }
    }
}
```

### Best Practices

1. **Use Descriptive Names**: Test names should clearly describe what is being tested
2. **Follow AAA Pattern**: Arrange, Act, Assert
3. **Isolate Tests**: Each test should be independent
4. **Clean Up**: Always clean up temporary files and settings
5. **Use Context Blocks**: Group related tests together
6. **Mock External Dependencies**: Don't rely on external systems
7. **Test Edge Cases**: Include tests for error conditions and boundaries

## Coverage Areas

### Currently Tested

✅ Core installation functions
✅ File detection and extra files management
✅ Parameter validation
✅ Tool-specific installation paths
✅ Include file processing
✅ DryRun mode
✅ Force and Backup flags
✅ Error handling

### Future Test Additions

- [ ] User interaction prompts (currently skipped in CI)
- [ ] Network-dependent features (WebFetch)
- [ ] Complex include file scenarios
- [ ] Performance benchmarks
- [ ] Code coverage metrics

## Troubleshooting

### Common Issues

**Issue**: Pester not found
```powershell
Install-Module -Name Pester -MinimumVersion 5.0.0 -Force -Scope CurrentUser
```

**Issue**: Permission errors in tests
- Run PowerShell as Administrator
- Or use `-Scope CurrentUser` for module installation

**Issue**: Tests fail on Linux/macOS
- Some tests are Windows-specific and will be skipped
- Check for platform-specific path separators

**Issue**: Temporary files not cleaned up
```powershell
# Manual cleanup if needed
Remove-Item -Path "$env:TEMP\AgentInstallTests_*" -Recurse -Force
```

## Test Metrics

The test suite provides:
- **Total test count**: Number of tests executed
- **Pass/Fail rates**: Success percentage
- **Execution time**: Performance metrics
- **Skip count**: Tests skipped (usually platform-specific)

## Contributing

When adding new features to the install script:
1. Write tests FIRST (TDD approach)
2. Ensure all existing tests pass
3. Add integration tests for complex scenarios
4. Update this documentation if needed
5. Run tests on all platforms before submitting PR

## Related Documentation

- [Installation Guide](../README.md)
- [PowerShell Style Guide](./common.ps1)
- [Pester Documentation](https://pester.dev/)
- [GitHub Actions Workflow](.github/workflows/test-install-script.yml)