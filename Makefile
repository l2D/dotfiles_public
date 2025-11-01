.PHONY: help install dock-preview dock-apply test-brewfile test-zsh clean

# Default target
help:
	@echo "Available targets:"
	@echo "  make install        - Run the full dotfiles installation"
	@echo "  make dock-preview   - Preview Dock configuration changes (dry-run)"
	@echo "  make dock-apply     - Apply Dock configuration"
	@echo "  make test-brewfile  - Validate Brewfile syntax"
	@echo "  make test-zsh       - Syntax check zsh configuration"
	@echo "  make clean          - Remove temporary installation directory"

# Run the full installation
install:
	@echo "Running dotfiles installation..."
	@bash install.sh

# Preview Dock configuration changes
dock-preview:
	@echo "Previewing Dock configuration..."
	@bash scripts/configure-dock.sh --dry-run

# Apply Dock configuration
dock-apply:
	@echo "Applying Dock configuration..."
	@bash scripts/configure-dock.sh

# Validate Brewfile syntax
test-brewfile:
	@echo "Validating Brewfile..."
	@if [ -f ~/.Brewfile ]; then \
		brew bundle check --global; \
	else \
		echo "Error: ~/.Brewfile not found. Run 'make install' first."; \
		exit 1; \
	fi

# Syntax check zsh configuration
test-zsh:
	@echo "Checking zsh configuration syntax..."
	@if [ -f ~/.zshrc ]; then \
		zsh -n ~/.zshrc && echo "✓ .zshrc syntax is valid"; \
	else \
		echo "Error: ~/.zshrc not found. Run 'make install' first."; \
		exit 1; \
	fi

# Clean up temporary installation directory
clean:
	@echo "Cleaning up..."
	@rm -rf ~/.dotfiles
	@echo "✓ Removed ~/.dotfiles directory"
