# My macOS Dotfiles

This repository contains my personal dotfiles for setting up a new macOS device. It includes a `Brewfile` with a comprehensive list of command-line tools and applications that I use for development, DevOps, and general productivity.

## 🚀 Installation

To set up a new device, run the following command in your terminal:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/l2D/dotfiles_public/main/install.sh)"
```

This will clone the repository to `~/.dotfiles` and execute the setup script.

## 🧐 How It Works

The installation script (`install.sh`) performs the following steps:

1. **Clones the Repository**: It clones this repository to `~/.dotfiles` on your local machine. If the directory already exists, it will pull the latest changes.
2. **Executes the Setup Script**: It runs the `setup_my_new_device.sh` script, which:
    * Installs [Homebrew](https://brew.sh/) if it's not already installed.
    * Installs all the packages, casks, and applications listed in the `Brewfile` using `brew bundle --global`.
    * Copies the configuration files (`.vimrc`, `.p10k.zsh`, `.zshrc`, etc.) to your home directory.

## 📦 What's Included?

Here's a list of the tools and applications that will be installed, categorized by their purpose.

### ☁️ Cloud Providers CLI

* **awscli**: Official Amazon AWS command-line interface
* **azure-cli**: Command-line tools for Azure
* **gcloud**: Google Cloud SDK command-line interface

### 🛠️ Development Tools

* **pyenv**: Python version management
* **gh**: GitHub command-line tool
* **mise**: Polyglot tool version manager
* **git**: Distributed revision control system
* **git-lfs**: Git extension for versioning large files
* **k6**: Modern load testing tool, using Go and JavaScript
* **nvm**: Manage multiple Node.js versions
* **vim**: Vi 'workalike' with many additional features
* **neovim**: Ambitious Vim-fork focused on extensibility and usability
* **watchman**: Watch files and take action when they change

### ☸️ DevOps & Kubernetes

* **kubernetes-cli**: Kubernetes command-line interface
* **act**: Run your GitHub Actions locally
* **argocd**: GitOps Continuous Delivery for Kubernetes
* **helm**: The Kubernetes package manager
* **infracost**: Cloud cost estimates for Terraform
* **istioctl**: Istio configuration command-line utility
* **kompose**: Tool to move from `docker-compose` to Kubernetes
* **kubectx**: Tool that can switch between kubectl contexts easily and create aliases
* **kustomize**: Customization of Kubernetes YAML configurations
* **terraform-docs**: Tool to generate documentation from Terraform modules
* **kind**: Kubernetes in Docker - local clusters for testing Kubernetes
* **k8sgpt**: Giving Kubernetes Superpowers to everyone
* **k9s**: Kubernetes CLI To Manage Your Clusters In Style!
* **vault**: Tool for securely accessing secrets
* **bk@3**: Buildkite CLI
* **helmfile**: Deploy Kubernetes Helm Charts

### 🛡️ DevSecOps & Security

* **pre-commit**: Framework for managing multi-language pre-commit hooks
* **trivy**: Scanner for vulnerabilities in container images, file systems, and Git repositories
* **infisical**: Backed by developers, open source, and secure
* **dependency-check**: OWASP dependency-check
* **gnutls**: GNU Transport Layer Security (TLS) Library
* **gnupg**: GNU Pretty Good Privacy (PGP) package
* **mkcert**: Simple tool for making locally-trusted development certificates
* **nss**: Libraries for security-enabled client and server applications

### 🌐 Networking

* **dog**: Command-line DNS client
* **httpie**: User-friendly cURL replacement
* **wget**: Internet file retriever

### miscellaneous

* **asciinema**: Record and share terminal sessions
* **bat**: Clone of cat(1) with syntax highlighting and Git integration
* **exa**: Modern replacement for 'ls'
* **fd**: Simple, fast and user-friendly alternative to 'find'
* **fzf**: Command-line fuzzy finder
* **htop**: Improved top (interactive process viewer)
* **jd**: JSON diff and patch utility
* **jq**: Lightweight and flexible command-line JSON processor
* **mas**: Mac App Store command-line interface
* **navi**: Interactive cheatsheet tool for the command-line
* **ripgrep**: Search tool like grep and The Silver Searcher
* **tldr**: Simplified and community-driven man pages
* **tokei**: Program that allows you to count code, quickly
* **tree**: Display directories as trees (with optional color/HTML output)
* **tz**: CLI time zone visualizer
* **yq**: Process YAML documents from the CLI

### GUI Applications (Casks)

* **1password**: Password manager
* **1password-cli**: Command-line interface for 1Password
* **docker-desktop**: Build and share containerized applications
* **font-hack-nerd-font**: Developer targeted font with icons
* **gitkraken**: Git client
* **gitkraken-cli**: GitKraken Command Line Interface
* **lens**: Kubernetes IDE
* **microsoft-teams**: Team collaboration software
* **rancher**: Container management platform
* **raycast**: Control your tools with a few keystrokes
* **setapp**: Collection of apps for macOS and iOS
* **signal**: Private messaging app
* **slack**: Team communication and collaboration software
* **visual-studio-code**: Open-source code editor
* **warp**: Modern, Rust-based terminal with AI built in
* **arc**: Web browser
* **rectangle-pro**: Window snapping tool
* **betterdisplay**: Display management tool
* **wins**: Bring your windows to your cursor
* **adguard**: Ad blocker
* **logi-options+**: Software for Logitech devices
* **aptakube**: Modern Kubernetes GUI client
* **orbstack**: Replacement for Docker Desktop
* **postman**: Collaboration platform for API development
* **postman-cli**: Command-line companion for Postman
* **apidog-europe**: All-in-one API development and testing tool

### Mac App Store Apps

* **Amphetamine**: Keep-awake utility

### Libraries

* **libyaml**: YAML C library
* **openssl@3**: Cryptography and SSL/TLS Toolkit

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
