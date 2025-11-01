.PHONY: help install dock-preview dock-apply test-brewfile test-zsh test test-unit clean

# Default target
help:
	@echo "Available targets:"
	@echo "  make install        - Run the full dotfiles installation"
	@echo "  make dock-preview   - Preview Dock configuration changes (dry-run)"
	@echo "  make dock-apply     - Apply Dock configuration"
	@echo "  make test           - Run all tests"
	@echo "  make test-unit      - Run unit tests for install.sh"
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

# Run all tests
test: test-unit
	@echo "✓ All tests passed"

# Run unit tests for install.sh
test-unit:
	@echo "Running unit tests..."
	@if command -v bats >/dev/null 2>&1; then \
		bats tests/install.bats; \
	else \
		echo "Error: bats not found. Install with 'brew install bats-core'"; \
		exit 1; \
	fi

# Clean up temporary installation directory
clean:
	@echo "Cleaning up..."
	@rm -rf ~/.dotfiles
	@echo "✓ Removed ~/.dotfiles directory"
