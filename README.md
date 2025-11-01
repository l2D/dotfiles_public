# My macOS Dotfiles

This repository contains my personal dotfiles for setting up a new macOS device. It includes a `Brewfile` with 100+ command-line tools and applications that I use for development, DevOps, and general productivity.

## 🚀 Installation

### Remote Installation (Bootstrap)

To set up a new device, run the following command in your terminal:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/l2D/dotfiles_public/main/install.sh)"
```

This will clone the repository to a temporary directory and execute the setup script.

### Local Installation

If you've already cloned the repository:

```bash
# Clone the repository (if not already cloned)
git clone https://github.com/l2D/dotfiles_public.git ~/.dotfiles
cd ~/.dotfiles

# Run installer directly
bash install.sh

# Or use make
make install
```

**Note:** During installation, you'll be prompted to:

- Configure your macOS Dock with preferred applications (optional)
- Delete the cloned repository after installation (optional)

### Prerequisites

- **Xcode Command Line Tools**: The installer will prompt for installation if not present
- **macOS**: This setup is designed specifically for macOS (Intel and Apple Silicon)

## 🧐 How It Works

The installation script (`install.sh`) is a self-contained installer that performs the following steps:

1. **Clones the Repository**: It clones this repository to a temporary `~/.dotfiles` directory on your local machine.
2. **Installs macOS Prerequisites**:
   - **Xcode Command Line Tools**: Prompts for installation if not already present.
   - **Rosetta 2**: Installs it on Apple Silicon Macs if needed.
3. **Installs Homebrew**: If not already installed, it will install Homebrew.
4. **Copies Dotfiles**: It copies all the necessary configuration files (`.vimrc`, `.p10k.zsh`, `.zshrc`, `.zprofile`, `Brewfile`, and `.config` files) to your home directory.
5. **Configures Homebrew**: It adds the Homebrew environment to your shell's `.zprofile`.
6. **Installs Packages**: It installs all the packages, casks, and applications listed in the `Brewfile` using `brew bundle --global`.
7. **Dock Configuration** (Optional): Prompts to configure your macOS Dock with preferred applications using `scripts/configure-dock.sh`.
8. **Cleanup** (Optional): Prompts to remove the temporary `~/.dotfiles` directory after installation.

**Interactive Prompts:**

- You can skip optional steps (Dock configuration, cleanup) by responding with 'n' or 'no'
- The installation will continue successfully even if optional steps are skipped or fail

## 🛠️ Makefile Commands

The repository includes a Makefile with convenient commands for common tasks:

| Command | Description |
|---------|-------------|
| `make help` | Display all available commands |
| `make install` | Run the full dotfiles installation |
| `make dock-preview` | Preview Dock configuration changes (dry-run) |
| `make dock-apply` | Apply Dock configuration |
| `make test` | Run all tests |
| `make test-unit` | Run unit tests for install.sh |
| `make test-brewfile` | Validate Brewfile syntax |
| `make test-zsh` | Syntax check zsh configuration |
| `make clean` | Remove temporary installation directory |

**Usage Examples:**

```bash
# Display available commands
make help

# Run full installation
make install

# Preview what Dock configuration would do
make dock-preview

# Apply Dock configuration
make dock-apply

# Run all tests
make test

# Validate Brewfile syntax (requires ~/.Brewfile)
make test-brewfile

# Clean up temporary files
make clean
```

## 📦 What's Included?

This repository installs 100+ packages organized by category:

### ☁️ Cloud Providers CLI

- **[aws-sso-cli](https://github.com/synfinatic/aws-sso-cli)**: Securely manage AWS API credentials using AWS SSO
- **[aws-vault](https://github.com/99designs/aws-vault)**: Secure, cross-platform tool for managing AWS credentials
- **[awscli](https://aws.amazon.com/cli/)**: Official Amazon AWS command-line interface
- **[azure-cli](https://docs.microsoft.com/en-us/cli/azure/)**: Command-line tools for Azure
- **[gcloud-cli](https://cloud.google.com/sdk/gcloud)**: Google Cloud SDK command-line interface

### 🐳 Container & Kubernetes

- **[helm](https://helm.sh/)**: The Kubernetes package manager
- **[istioctl](https://istio.io/latest/docs/reference/commands/istioctl/)**: Istio configuration command-line utility
- **[k9s](https://k9scli.io/)**: Kubernetes CLI to manage clusters in style
- **[kind](https://kind.sigs.k8s.io/)**: Kubernetes in Docker - local clusters for testing
- **[kompose](https://kompose.io/)**: Tool to move from docker-compose to Kubernetes
- **[kubectx](https://github.com/ahmetb/kubectx)**: Switch between kubectl contexts easily
- **[kubernetes-cli](https://kubernetes.io/docs/reference/kubectl/)**: Kubernetes command-line interface
- **[kustomize](https://kustomize.io/)**: Customization of Kubernetes YAML configurations

### 🏭 Infrastructure as Code

- **[terraform](https://www.terraform.io/)**: Infrastructure as code software tool
- **[infracost](https://www.infracost.io/)**: Cloud cost estimates for Terraform
- **[terraform-docs](https://terraform-docs.io/)**: Generate documentation from Terraform modules
- **[terragrunt](https://terragrunt.gruntwork.io/)**: Thin wrapper for Terraform providing extra tools

### 🔄 DevOps & CI/CD

- **[act](https://github.com/nektos/act)**: Run your GitHub Actions locally
- **[argocd](https://argo-cd.readthedocs.io/)**: GitOps Continuous Delivery for Kubernetes
- **[bk@3](https://buildkite.com/docs/platform/cli/installation)**: Buildkite CLI
- **[helmfile](https://helmfile.readthedocs.io/)**: Deploy Kubernetes Helm Charts

### 🔐 Security & Secrets Management

- **[dependency-check](https://owasp.org/www-project-dependency-check/)**: OWASP dependency-check
- **[gnupg](https://gnupg.org/)**: GNU Pretty Good Privacy (PGP) package
- **[vault](https://www.vaultproject.io/)**: Tool for securely accessing secrets
- **[infisical](https://infisical.com/)**: Open source secrets management platform
- **[mkcert](https://github.com/FiloSottile/mkcert)**: Make locally-trusted development certificates
- **[nss](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS)**: Libraries for security-enabled applications
- **[pre-commit](https://pre-commit.com/)**: Framework for managing multi-language pre-commit hooks
- **[trivy](https://trivy.dev/)**: Vulnerability scanner for containers and IaC

### 👩‍💻 Programming Languages & Runtimes

- **[cloudflare-wrangler](https://developers.cloudflare.com/workers/wrangler/)**: Cloudflare Workers CLI
- **[go](https://go.dev/)**: Open source programming language
- **[bun](https://bun.sh/)**: Fast JavaScript runtime

### 🔄 Version Managers

- **[mise](https://mise.jdx.dev/)**: Polyglot tool version manager
- **[pyenv](https://github.com/pyenv/pyenv)**: Python version management
- **[nvm](https://github.com/nvm-sh/nvm)**: Manage multiple Node.js versions

### 📦 Package Managers

- **[pnpm](https://pnpm.io/)**: Fast, disk space efficient package manager
- **[yarn](https://yarnpkg.com/)**: Fast, reliable dependency management

### 🌱 Git & Version Control

- **[gh](https://cli.github.com/)**: GitHub command-line tool
- **[git](https://git-scm.com/)**: Distributed revision control system
- **[git-lfs](https://git-lfs.github.io/)**: Git extension for versioning large files

### ✏️ Development Tools & Editors

- **[vim](https://www.vim.org/)**: Vi 'workalike' with many additional features
- **[neovim](https://neovim.io/)**: Ambitious Vim-fork focused on extensibility
- **[watchman](https://facebook.github.io/watchman/)**: Watch files and take action when they change

### 🧪 Testing & Performance

- **[k6](https://k6.io/)**: Modern load testing tool

### 🌐 Networking & HTTP

- **[dog](https://github.com/ogham/dog)**: Command-line DNS client
- **[httpie](https://httpie.io/)**: User-friendly cURL replacement
- **[wget](https://www.gnu.org/software/wget/)**: Internet file retriever

### 📡 CLI Utilities

- **[asciinema](https://asciinema.org/)**: Record and share terminal sessions
- **[bat](https://github.com/sharkdp/bat)**: Cat clone with syntax highlighting
- **[dockutil](https://github.com/kcrawford/dockutil)**: Tool for managing macOS Dock items
- **[exa](https://the.exa.website/)**: Modern replacement for 'ls'
- **[fd](https://github.com/sharkdp/fd)**: Simple, fast alternative to 'find'
- **[fzf](https://github.com/junegunn/fzf)**: Command-line fuzzy finder
- **[htop](https://htop.dev/)**: Improved top (interactive process viewer)
- **[jd](https://github.com/josephburnett/jd)**: JSON diff and patch utility
- **[jq](https://jqlang.github.io/jq/)**: Lightweight command-line JSON processor
- **[mas](https://github.com/mas-cli/mas)**: Mac App Store command-line interface
- **[navi](https://github.com/denisidoro/navi)**: Interactive cheatsheet tool
- **[ripgrep](https://github.com/BurntSushi/ripgrep)**: Search tool like grep
- **[tldr](https://tldr.sh/)**: Simplified and community-driven man pages
- **[tokei](https://github.com/XAMPPRocky/tokei)**: Count code quickly
- **[tree](https://oldmanprogrammer.net/source.php?dir=projects/tree)**: Display directories as trees
- **[tz](https://github.com/oz/tz)**: CLI time zone visualizer
- **[yq](https://github.com/mikefarah/yq)**: Process YAML documents from the CLI

### 📚 System Libraries

- **[gnutls](https://www.gnutls.org/)**: GNU Transport Layer Security (TLS) Library
- **[libyaml](https://pyyaml.org/wiki/LibYAML)**: YAML C library
- **[openssl@3](https://www.openssl.org/)**: Cryptography and SSL/TLS Toolkit

### 💻 GUI Applications

#### Browsers

- **[arc](https://arc.net/)**: Web browser

#### Terminal

- **[warp](https://www.warp.dev/)**: Modern, Rust-based terminal with AI

#### Productivity

- **[1password](https://1password.com/)**: Password manager
- **[1password-cli](https://developer.1password.com/docs/cli/)**: Command-line interface for 1Password
- **[adguard](https://adguard.com/)**: Ad blocker
- **[betterdisplay](https://github.com/waydabber/BetterDisplay)**: Display management tool
- **[logi-options+](https://www.logitech.com/en-us/software/logi-options-plus.html)**: Software for Logitech devices
- **[microsoft-teams](https://www.microsoft.com/en-us/microsoft-teams)**: Team collaboration software
- **[raycast](https://www.raycast.com/)**: Control your tools with a few keystrokes
- **[rectangle-pro](https://rectangleapp.com/pro)**: Window snapping tool
- **[setapp](https://setapp.com/)**: Collection of apps for macOS and iOS
- **[slack](https://slack.com/)**: Team communication and collaboration
- **[wins](https://wins.cool/)**: Bring your windows to your cursor

#### Development

- **[apidog-europe](https://apidog.com/)**: All-in-one API development tool
- **[aptakube](https://aptakube.com/)**: Modern Kubernetes GUI client
- **[docker-desktop](https://www.docker.com/products/docker-desktop/)**: Build and share containerized applications
- **[gitkraken](https://www.gitkraken.com/)**: Git client
- **[gitkraken-cli](https://help.gitkraken.com/cli/cli-home/)**: GitKraken Command Line Interface
- **[visual-studio-code](https://code.visualstudio.com/)**: Open-source code editor

#### Fonts

- **[font-hack-nerd-font](https://www.nerdfonts.com/)**: Developer targeted font with icons

### 🏪 Mac App Store Apps

- **[Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704)** (ID: 937984704): Keep-awake utility

## 🧪 Testing

This repository includes a comprehensive test suite using BATS (Bash Automated Testing System) to verify the installation script's behavior.

### Prerequisites

Install BATS via Homebrew:

```bash
brew install bats-core
```

### Running Tests

**Using Make (Recommended):**

```bash
# Run all tests
make test

# Run unit tests for install.sh
make test-unit

# Validate Brewfile syntax (requires ~/.Brewfile)
make test-brewfile

# Syntax check zsh configuration (requires ~/.zshrc)
make test-zsh
```

**Direct Execution:**

```bash
# Run all tests
bats tests/install.bats

# Run specific tests matching a pattern
bats tests/install.bats -f "Dock configuration"

# Run with verbose output
bats tests/install.bats --print-output-on-failure
```

### Test Coverage

The test suite covers:

1. **Dock Configuration Tests**
   - User accepts/declines Dock configuration
   - Case-insensitive responses (y/yes/Y/YES, n/no/N/NO)
   - Invalid input handling
   - Dry-run mode

2. **Installation Resilience**
   - Installation continues even if Dock configuration fails
   - Error handling for missing prerequisites

3. **Repository Cleanup Tests**
   - User accepts/declines repository deletion
   - Case-insensitive responses
   - Repository retention on invalid input

4. **File Operations**
   - Dotfiles copied correctly to home directory
   - Directory structure preserved

### Test Files

- **`tests/install.bats`**: Main BATS test suite with 21 test cases
- **`tests/README.md`**: Detailed testing documentation

For more information about the test suite, see [`tests/README.md`](tests/README.md).

## 🔧 Helper Scripts

### Dock Configuration

The `scripts/configure-dock.sh` script automates the configuration of your macOS Dock by removing unwanted apps and adding/ordering your preferred applications.

**Usage:**

```bash
# Preview changes without applying them (dry-run)
./scripts/configure-dock.sh --dry-run
# Or using make
make dock-preview

# Apply dock configuration
./scripts/configure-dock.sh
# Or using make
make dock-apply
```

**Prerequisites:**

- `dockutil` (automatically installed via Brewfile)

**What it does:**

- Removes default macOS apps you don't use (Safari, Mail, Maps, Photos, FaceTime, etc.)
- Adds and orders your preferred applications (Arc, Warp, GitKraken, Docker, Slack, etc.)
- Restarts the Dock to apply changes

**Note:** The `install.sh` script will offer to run Dock configuration automatically during installation.

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
