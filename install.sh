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

# Install Homebrew if it's not installed
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

# Place files at Home directory
echo "Placing files at Home directory..."
cp -f Brewfile ~/Brewfile
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

# Clean up the cloned repository
echo "Cleaning up installation files..."
rm -rf "$INSTALL_DIR"

echo "Installation complete!"
echo "Your new shell configuration will be loaded in your next terminal session."
