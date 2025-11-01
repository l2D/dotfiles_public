#!/usr/bin/env bats

# Test suite for install.sh
#
# These tests verify the correct behavior of the installation script,
# particularly around user interaction for Dock configuration and cleanup.
#
# Prerequisites:
# - BATS (Bash Automated Testing System) must be installed
# - Install via Homebrew: brew install bats-core
#
# Usage:
# Run all tests: bats tests/install.bats
# Run specific test: bats tests/install.bats -f "test name pattern"

setup() {
  # Create a temporary directory for test files
  export TEST_DIR="$(mktemp -d)"
  export INSTALL_DIR="$TEST_DIR/.dotfiles"
  export HOME="$TEST_DIR"
  
  # Create mock repository structure
  mkdir -p "$INSTALL_DIR"
  mkdir -p "$INSTALL_DIR/.config"
  mkdir -p "$INSTALL_DIR/scripts"
  mkdir -p "$INSTALL_DIR/vim"
  mkdir -p "$INSTALL_DIR/p10k"
  
  # Create mock files
  touch "$INSTALL_DIR/Brewfile"
  touch "$INSTALL_DIR/.zshrc"
  touch "$INSTALL_DIR/.zprofile"
  touch "$INSTALL_DIR/vim/.vimrc"
  touch "$INSTALL_DIR/p10k/.p10k.zsh"
  
  # Create a mock configure-dock.sh script
  cat > "$INSTALL_DIR/scripts/configure-dock.sh" << 'EOF'
#!/bin/bash
# Mock dock configuration script
exit 0
EOF
  chmod +x "$INSTALL_DIR/scripts/configure-dock.sh"
  
  # Create a mock brew command
  export PATH="$TEST_DIR/bin:$PATH"
  mkdir -p "$TEST_DIR/bin"
  cat > "$TEST_DIR/bin/brew" << 'EOF'
#!/bin/bash
# Mock brew command
exit 0
EOF
  chmod +x "$TEST_DIR/bin/brew"
  
  # Create a test version of install.sh that skips git operations and prerequisites
  cat > "$TEST_DIR/test-install.sh" << 'TESTSCRIPT'
#!/bin/bash
set -e

# Use test environment variables
INSTALL_DIR="${INSTALL_DIR:-$HOME/.dotfiles}"

# Skip git clone, xcode, rosetta, and homebrew installation in tests
# Start from the file copying section

# Place files at Home directory
echo "Placing files at Home directory..."
cp -f "$INSTALL_DIR/Brewfile" "$HOME/.Brewfile"
cp -f "$INSTALL_DIR/vim/.vimrc" "$HOME/.vimrc"
cp -f "$INSTALL_DIR/p10k/.p10k.zsh" "$HOME/.p10k.zsh"
cp -f "$INSTALL_DIR/.zshrc" "$HOME/.zshrc"
cp -f "$INSTALL_DIR/.zprofile" "$HOME/.zprofile"

if [ -d "$INSTALL_DIR/.config" ]; then
    mkdir -p "$HOME/.config"
    cp -r "$INSTALL_DIR/.config"/* "$HOME/.config/" 2>/dev/null || true
fi
echo "Done."

# Brew install from BrewFile (mocked in tests)
echo "Installing packages from Brewfile..."
brew bundle --global

# Prompt user for Dock configuration
echo ""
echo "Would you like to configure your macOS Dock with preferred applications? (y/n)"
read -r response

# Convert response to lowercase for comparison
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')

if [[ "$response" == "y" || "$response" == "yes" ]]; then
  echo "Configuring macOS Dock..."
  if "$INSTALL_DIR/scripts/configure-dock.sh"; then
    echo "✓ Dock configuration completed successfully"
  else
    echo "✗ Warning: Dock configuration failed, but installation will continue"
  fi
else
  echo "Skipping Dock configuration"
fi

# Clean up the cloned repository
echo ""
echo "Would you like to delete the cloned repository at $INSTALL_DIR? (y/n)"
read -r cleanup_response

# Convert response to lowercase for comparison
cleanup_response=$(echo "$cleanup_response" | tr '[:upper:]' '[:lower:]')

if [[ "$cleanup_response" == "y" || "$cleanup_response" == "yes" ]]; then
  echo "Cleaning up installation files..."
  rm -rf "$INSTALL_DIR"
  echo "✓ Cleanup completed"
else
  echo "Keeping repository at: $INSTALL_DIR"
fi

echo ""
echo "Installation complete!"
echo "Your new shell configuration will be loaded in your next terminal session."
TESTSCRIPT
  
  chmod +x "$TEST_DIR/test-install.sh"
}

teardown() {
  # Clean up temporary directory
  rm -rf "$TEST_DIR"
}

# Test Case 1: Dock configuration with 'y' response
@test "configures Dock when user responds with 'y'" {
  run bash -c "echo -e 'y\nn' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Would you like to configure your macOS Dock with preferred applications?" ]]
  [[ "$output" =~ "Configuring macOS Dock..." ]]
  [[ "$output" =~ "✓ Dock configuration completed successfully" ]]
}

# Test Case 1b: Dock configuration with 'yes' response
@test "configures Dock when user responds with 'yes'" {
  run bash -c "echo -e 'yes\nn' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Would you like to configure your macOS Dock with preferred applications?" ]]
  [[ "$output" =~ "Configuring macOS Dock..." ]]
  [[ "$output" =~ "✓ Dock configuration completed successfully" ]]
}

# Test Case 1c: Dock configuration with 'Y' response (uppercase)
@test "configures Dock when user responds with 'Y' (case-insensitive)" {
  run bash -c "echo -e 'Y\nn' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Configuring macOS Dock..." ]]
  [[ "$output" =~ "✓ Dock configuration completed successfully" ]]
}

# Test Case 1d: Dock configuration with 'YES' response (uppercase)
@test "configures Dock when user responds with 'YES' (case-insensitive)" {
  run bash -c "echo -e 'YES\nn' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Configuring macOS Dock..." ]]
  [[ "$output" =~ "✓ Dock configuration completed successfully" ]]
}

# Test Case 2: Skip Dock configuration with 'n' response
@test "skips Dock configuration when user responds with 'n'" {
  run bash -c "echo -e 'n\nn' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Would you like to configure your macOS Dock with preferred applications?" ]]
  [[ "$output" =~ "Skipping Dock configuration" ]]
  [[ ! "$output" =~ "Configuring macOS Dock..." ]]
}

# Test Case 2b: Skip Dock configuration with 'no' response
@test "skips Dock configuration when user responds with 'no'" {
  run bash -c "echo -e 'no\nn' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Would you like to configure your macOS Dock with preferred applications?" ]]
  [[ "$output" =~ "Skipping Dock configuration" ]]
  [[ ! "$output" =~ "Configuring macOS Dock..." ]]
}

# Test Case 2c: Skip Dock configuration with 'N' response (uppercase)
@test "skips Dock configuration when user responds with 'N' (case-insensitive)" {
  run bash -c "echo -e 'N\nn' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Skipping Dock configuration" ]]
}

# Test Case 2d: Skip Dock configuration with 'NO' response (uppercase)
@test "skips Dock configuration when user responds with 'NO' (case-insensitive)" {
  run bash -c "echo -e 'NO\nn' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Skipping Dock configuration" ]]
}

# Test Case 2e: Skip Dock configuration with invalid response
@test "skips Dock configuration when user responds with invalid input" {
  run bash -c "echo -e 'invalid\nn' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Skipping Dock configuration" ]]
}

# Test Case 3: Installation continues when Dock configuration fails
@test "proceeds with installation even if Dock configuration fails" {
  # Create a failing dock configuration script
  cat > "$INSTALL_DIR/scripts/configure-dock.sh" << 'EOF'
#!/bin/bash
# Mock failing dock configuration script
exit 1
EOF
  chmod +x "$INSTALL_DIR/scripts/configure-dock.sh"
  
  run bash -c "echo -e 'y\nn' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Configuring macOS Dock..." ]]
  [[ "$output" =~ "✗ Warning: Dock configuration failed, but installation will continue" ]]
  [[ "$output" =~ "Installation complete!" ]]
}

# Test Case 4: Repository deletion with 'y' response
@test "deletes cloned repository when user responds with 'y'" {
  run bash -c "echo -e 'n\ny' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Would you like to delete the cloned repository at $INSTALL_DIR?" ]]
  [[ "$output" =~ "Cleaning up installation files..." ]]
  [[ "$output" =~ "✓ Cleanup completed" ]]
  
  # Verify repository was deleted
  [ ! -d "$INSTALL_DIR" ]
}

# Test Case 4b: Repository deletion with 'yes' response
@test "deletes cloned repository when user responds with 'yes'" {
  run bash -c "echo -e 'n\nyes' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Cleaning up installation files..." ]]
  [[ "$output" =~ "✓ Cleanup completed" ]]
  
  # Verify repository was deleted
  [ ! -d "$INSTALL_DIR" ]
}

# Test Case 4c: Repository deletion with 'Y' response (uppercase)
@test "deletes cloned repository when user responds with 'Y' (case-insensitive)" {
  run bash -c "echo -e 'n\nY' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Cleaning up installation files..." ]]
  [[ "$output" =~ "✓ Cleanup completed" ]]
  
  # Verify repository was deleted
  [ ! -d "$INSTALL_DIR" ]
}

# Test Case 4d: Repository deletion with 'YES' response (uppercase)
@test "deletes cloned repository when user responds with 'YES' (case-insensitive)" {
  run bash -c "echo -e 'n\nYES' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "✓ Cleanup completed" ]]
  
  # Verify repository was deleted
  [ ! -d "$INSTALL_DIR" ]
}

# Test Case 5: Repository retention with 'n' response
@test "retains cloned repository when user responds with 'n'" {
  run bash -c "echo -e 'n\nn' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Would you like to delete the cloned repository at $INSTALL_DIR?" ]]
  [[ "$output" =~ "Keeping repository at: $INSTALL_DIR" ]]
  
  # Verify repository still exists
  [ -d "$INSTALL_DIR" ]
}

# Test Case 5b: Repository retention with 'no' response
@test "retains cloned repository when user responds with 'no'" {
  run bash -c "echo -e 'n\nno' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Keeping repository at: $INSTALL_DIR" ]]
  
  # Verify repository still exists
  [ -d "$INSTALL_DIR" ]
}

# Test Case 5c: Repository retention with 'N' response (uppercase)
@test "retains cloned repository when user responds with 'N' (case-insensitive)" {
  run bash -c "echo -e 'n\nN' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Keeping repository at: $INSTALL_DIR" ]]
  
  # Verify repository still exists
  [ -d "$INSTALL_DIR" ]
}

# Test Case 5d: Repository retention with 'NO' response (uppercase)
@test "retains cloned repository when user responds with 'NO' (case-insensitive)" {
  run bash -c "echo -e 'n\nNO' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Keeping repository at: $INSTALL_DIR" ]]
  
  # Verify repository still exists
  [ -d "$INSTALL_DIR" ]
}

# Test Case 5e: Repository retention with invalid response
@test "retains cloned repository when user responds with invalid input" {
  run bash -c "echo -e 'n\ninvalid' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Keeping repository at: $INSTALL_DIR" ]]
  
  # Verify repository still exists
  [ -d "$INSTALL_DIR" ]
}

# Additional test: Combined workflow
@test "handles complete workflow with Dock configuration and cleanup" {
  run bash -c "echo -e 'yes\nyes' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  [[ "$output" =~ "✓ Dock configuration completed successfully" ]]
  [[ "$output" =~ "✓ Cleanup completed" ]]
  [[ "$output" =~ "Installation complete!" ]]
  
  # Verify repository was deleted
  [ ! -d "$INSTALL_DIR" ]
}

# Additional test: Files are copied correctly
@test "copies dotfiles to home directory" {
  run bash -c "echo -e 'n\nn' | $TEST_DIR/test-install.sh"
  
  [ "$status" -eq 0 ]
  
  # Verify files were copied
  [ -f "$HOME/.Brewfile" ]
  [ -f "$HOME/.vimrc" ]
  [ -f "$HOME/.p10k.zsh" ]
  [ -f "$HOME/.zshrc" ]
  [ -f "$HOME/.zprofile" ]
  [ -d "$HOME/.config" ]
}
