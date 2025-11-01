# Testing Documentation

This directory contains unit tests for the dotfiles installation script.

## Prerequisites

Install BATS (Bash Automated Testing System):

```bash
brew install bats-core
```

## Running Tests

### Run all tests

```bash
bats tests/install.bats
```

### Run specific tests

```bash
# Run tests matching a pattern
bats tests/install.bats -f "Dock configuration"

# Run tests matching specific case
bats tests/install.bats -f "configures Dock when user responds with 'y'"
```

### Verbose output

```bash
# Show detailed test output
bats tests/install.bats --print-output-on-failure

# Show all output (including passing tests)
bats tests/install.bats --show-output-of-passing-tests
```

## Test Coverage

The test suite covers the following scenarios:

### 1. Dock Configuration Tests

- ✅ Configures Dock when user responds with 'y'
- ✅ Configures Dock when user responds with 'yes'
- ✅ Configures Dock when user responds with 'Y' (case-insensitive)
- ✅ Configures Dock when user responds with 'YES' (case-insensitive)
- ✅ Skips Dock configuration when user responds with 'n'
- ✅ Skips Dock configuration when user responds with 'no'
- ✅ Skips Dock configuration when user responds with 'N' (case-insensitive)
- ✅ Skips Dock configuration when user responds with 'NO' (case-insensitive)
- ✅ Skips Dock configuration when user responds with invalid input

### 2. Installation Resilience Tests

- ✅ Proceeds with installation even if Dock configuration fails

### 3. Repository Cleanup Tests

- ✅ Deletes cloned repository when user responds with 'y'
- ✅ Deletes cloned repository when user responds with 'yes'
- ✅ Deletes cloned repository when user responds with 'Y' (case-insensitive)
- ✅ Deletes cloned repository when user responds with 'YES' (case-insensitive)
- ✅ Retains cloned repository when user responds with 'n'
- ✅ Retains cloned repository when user responds with 'no'
- ✅ Retains cloned repository when user responds with 'N' (case-insensitive)
- ✅ Retains cloned repository when user responds with 'NO' (case-insensitive)
- ✅ Retains cloned repository when user responds with invalid input

### 4. Additional Tests

- ✅ Handles complete workflow with Dock configuration and cleanup
- ✅ Copies dotfiles to home directory correctly

## Test Structure

### Test Environment

Each test runs in an isolated environment with:

- Temporary `HOME` directory
- Mock repository structure in `~/.dotfiles`
- Mock `brew` command
- Mock `configure-dock.sh` script

### Setup and Teardown

- `setup()`: Creates temporary test environment before each test
- `teardown()`: Cleans up temporary files after each test

### Mock Components

The tests use a modified version of `install.sh` that:

- Skips git clone operations
- Skips Xcode Command Line Tools installation
- Skips Rosetta 2 installation
- Skips actual Homebrew installation
- Uses mocked `brew` command
- Uses mocked `configure-dock.sh` script

This allows tests to focus on the user interaction logic and file operations without requiring external dependencies or system modifications.

## Expected Output

When all tests pass, you should see:

```
 ✓ configures Dock when user responds with 'y'
 ✓ configures Dock when user responds with 'yes'
 ✓ configures Dock when user responds with 'Y' (case-insensitive)
 ✓ configures Dock when user responds with 'YES' (case-insensitive)
 ✓ skips Dock configuration when user responds with 'n'
 ✓ skips Dock configuration when user responds with 'no'
 ✓ skips Dock configuration when user responds with 'N' (case-insensitive)
 ✓ skips Dock configuration when user responds with 'NO' (case-insensitive)
 ✓ skips Dock configuration when user responds with invalid input
 ✓ proceeds with installation even if Dock configuration fails
 ✓ deletes cloned repository when user responds with 'y'
 ✓ deletes cloned repository when user responds with 'yes'
 ✓ deletes cloned repository when user responds with 'Y' (case-insensitive)
 ✓ deletes cloned repository when user responds with 'YES' (case-insensitive)
 ✓ retains cloned repository when user responds with 'n'
 ✓ retains cloned repository when user responds with 'no'
 ✓ retains cloned repository when user responds with 'N' (case-insensitive)
 ✓ retains cloned repository when user responds with 'NO' (case-insensitive)
 ✓ retains cloned repository when user responds with invalid input
 ✓ handles complete workflow with Dock configuration and cleanup
 ✓ copies dotfiles to home directory

21 tests, 0 failures
```

## Continuous Integration

These tests can be integrated into a CI/CD pipeline (e.g., GitHub Actions) to automatically verify changes to the installation script.

Example GitHub Actions workflow:

```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - name: Install BATS
        run: brew install bats-core
      - name: Run tests
        run: bats tests/install.bats
```

## Troubleshooting

### Tests fail with "command not found: bats"

Install BATS:

```bash
brew install bats-core
```

### Tests fail with permission errors

Ensure the test file is executable:

```bash
chmod +x tests/install.bats
```

### Individual test failures

Run the specific failing test with verbose output:

```bash
bats tests/install.bats -f "test name" --print-output-on-failure
```
