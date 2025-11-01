#!/bin/bash
#
# This script bootstraps the dotfiles installation.
# It clones the repository, installs dependencies, copies dotfiles,
# and then cleans up after itself.
#
set -e # Exit on error

# Define repository details
GITHUB_USER="l2D"
GITHUB_REPO="dotfiles_public"
REPO_URL="https://github.com/$GITHUB_USER/$GITHUB_REPO.git"
INSTALL_DIR="$HOME/.dotfiles"

# Clone or update the repository
if [ -d "$INSTALL_DIR" ]; then
  echo "Updating existing repository in $INSTALL_DIR"
  git -C "$INSTALL_DIR" pull
else
  echo "Cloning repository to $INSTALL_DIR"
  git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
fi

# Change to the installation directory
cd "$INSTALL_DIR"

# Install macOS prerequisites
if [[ "$(uname)" == "Darwin" ]]; then
  echo "Running on macOS. Installing prerequisites..."

  # Install Xcode Command Line Tools
  if ! xcode-select -p &>/dev/null; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
    echo ""
    echo "⏳ Waiting for Xcode Command Line Tools installation to complete..."
    echo "   Please complete the installation dialog that appeared."
    echo ""
    
    # Wait for xcode-select to be available
    until xcode-select -p &>/dev/null; do
      sleep 5
    done
    
    echo "✓ Xcode Command Line Tools installation completed"
    echo ""
  else
    echo "Xcode Command Line Tools are already installed."
  fi

  # Install Rosetta 2 on Apple Silicon Macs
  if [[ "$(uname -m)" == "arm64" ]]; then
    if ! /usr/bin/pgrep -q oahd; then
      echo "Rosetta 2 not found. Installing..."
      # Suppress cosmetic warning about missing installKBytes attribute (installation still succeeds)
      sudo softwareupdate --install-rosetta --agree-to-license 2>/dev/null || true
      echo "✓ Rosetta 2 installation completed"
    else
      echo "Rosetta 2 is already installed."
    fi
  fi
fi

# Install Homebrew if it's not installed
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# Ensure Homebrew is available in the current shell session
# This is critical because we'll be copying .zprofile next, and then need to run brew commands
eval "$(/opt/homebrew/bin/brew shellenv)"

# Place files at Home directory
echo "Placing files at Home directory..."
cp -f Brewfile ~/.Brewfile
cp -f vim/.vimrc ~/.vimrc
cp -f p10k/.p10k.zsh ~/.p10k.zsh
cp -f .zshrc ~/.zshrc
cp -f .zprofile ~/.zprofile
# Copy contents of .config recursively
if [ -d ".config" ]; then
    mkdir -p ~/.config
    cp -r .config/* ~/.config/
fi
echo "Done."

# Brew install from BrewFile
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
