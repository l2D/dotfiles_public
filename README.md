# My macOS Dotfiles

This repository contains my personal dotfiles for setting up a new macOS device. It includes a `Brewfile` with a comprehensive list of command-line tools and applications that I use for development, DevOps, and general productivity.

## 🚀 Installation

To set up a new device, run the following command in your terminal:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/l2D/dotfiles_public/main/install.sh)"
```

This will clone the repository to a temporary directory and execute the setup script.

## 🧐 How It Works

The installation script (`install.sh`) is a self-contained installer that performs the following steps:

1. **Clones the Repository**: It clones this repository to a temporary `~/.dotfiles` directory on your local machine.
2. **Installs macOS Prerequisites**:
   * **Xcode Command Line Tools**: Prompts for installation if not already present.
   * **Rosetta 2**: Installs it on Apple Silicon Macs if needed.
3. **Installs Homebrew**: If not already installed, it will install Homebrew.
4. **Copies Dotfiles**: It copies all the necessary configuration files (`.vimrc`, `.p10k.zsh`, `.zshrc`, `.zprofile`, `Brewfile`, and `.config` files) to your home directory.
5. **Configures Homebrew**: It adds the Homebrew environment to your shell's `.zprofile`.
6. **Installs Packages**: It installs all the packages, casks, and applications listed in the `Brewfile` using `brew bundle --global`.
7. **Cleans Up**: It removes the temporary `~/.dotfiles` directory after the installation is complete.

## 📦 What's Included?

Here's a list of the tools and applications that will be installed, categorized by their purpose.

### ☁️ Cloud Providers CLI

* **[awscli](https://aws.amazon.com/cli/)**: Official Amazon AWS command-line interface
* **[azure-cli](https://docs.microsoft.com/en-us/cli/azure/)**: Command-line tools for Azure
* **[gcloud](https://cloud.google.com/sdk/gcloud)**: Google Cloud SDK command-line interface

### 🛠️ Development Tools

* **[pyenv](https://github.com/pyenv/pyenv)**: Python version management
* **[gh](https://cli.github.com/)**: GitHub command-line tool
* **[mise](https://mise.jdx.dev/)**: Polyglot tool version manager
* **[git](https://git-scm.com/)**: Distributed revision control system
* **[git-lfs](https://git-lfs.github.io/)**: Git extension for versioning large files
* **[k6](https://k6.io/)**: Modern load testing tool, using Go and JavaScript
* **[nvm](https://github.com/nvm-sh/nvm)**: Manage multiple Node.js versions
* **[vim](https://www.vim.org/)**: Vi 'workalike' with many additional features
* **[neovim](https://neovim.io/)**: Ambitious Vim-fork focused on extensibility and usability
* **[watchman](https://facebook.github.io/watchman/)**: Watch files and take action when they change

### ☸️ DevOps & Kubernetes

* **[kubernetes-cli](https://kubernetes.io/docs/reference/kubectl/)**: Kubernetes command-line interface
* **[act](https://github.com/nektos/act)**: Run your GitHub Actions locally
* **[argocd](https://argo-cd.readthedocs.io/)**: GitOps Continuous Delivery for Kubernetes
* **[helm](https://helm.sh/)**: The Kubernetes package manager
* **[infracost](https://www.infracost.io/)**: Cloud cost estimates for Terraform
* **[istioctl](https://istio.io/latest/docs/reference/commands/istioctl/)**: Istio configuration command-line utility
* **[kompose](https://kompose.io/)**: Tool to move from `docker-compose` to Kubernetes
* **[kubectx](https://github.com/ahmetb/kubectx)**: Tool that can switch between kubectl contexts easily and create aliases
* **[kustomize](https://kustomize.io/)**: Customization of Kubernetes YAML configurations
* **[terraform-docs](https://terraform-docs.io/)**: Tool to generate documentation from Terraform modules
* **[kind](https://kind.sigs.k8s.io/)**: Kubernetes in Docker - local clusters for testing Kubernetes
* **[k8sgpt](https://k8sgpt.ai/)**: Giving Kubernetes Superpowers to everyone
* **[k9s](https://k9scli.io/)**: Kubernetes CLI To Manage Your Clusters In Style!
* **[vault](https://www.vaultproject.io/)**: Tool for securely accessing secrets
* **[bk@3](https://buildkite.com/docs/platform/cli/installation)**: Buildkite CLI
* **[helmfile](https://helmfile.readthedocs.io/)**: Deploy Kubernetes Helm Charts

### 🛡️ DevSecOps & Security

* **[pre-commit](https://pre-commit.com/)**: Framework for managing multi-language pre-commit hooks
* **[trivy](https://trivy.dev/)**: Scanner for vulnerabilities in container images, file systems, and Git repositories
* **[infisical](https://infisical.com/)**: Backed by developers, open source, and secure
* **[dependency-check](https://owasp.org/www-project-dependency-check/)**: OWASP dependency-check
* **[gnutls](https://www.gnutls.org/)**: GNU Transport Layer Security (TLS) Library
* **[gnupg](https://gnupg.org/)**: GNU Pretty Good Privacy (PGP) package
* **[mkcert](https://github.com/FiloSottile/mkcert)**: Simple tool for making locally-trusted development certificates
* **[nss](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS)**: Libraries for security-enabled client and server applications

### 🌐 Networking

* **[dog](https://github.com/ogham/dog)**: Command-line DNS client
* **[httpie](https://httpie.io/)**: User-friendly cURL replacement
* **[wget](https://www.gnu.org/software/wget/)**: Internet file retriever

### miscellaneous

* **[asciinema](https://asciinema.org/)**: Record and share terminal sessions
* **[bat](https://github.com/sharkdp/bat)**: Clone of cat(1) with syntax highlighting and Git integration
* **[exa](https://the.exa.website/)**: Modern replacement for 'ls'
* **[fd](https://github.com/sharkdp/fd)**: Simple, fast and user-friendly alternative to 'find'
* **[fzf](https://github.com/junegunn/fzf)**: Command-line fuzzy finder
* **[htop](https://htop.dev/)**: Improved top (interactive process viewer)
* **[jd](https://github.com/josephburnett/jd)**: JSON diff and patch utility
* **[jq](https://jqlang.github.io/jq/)**: Lightweight and flexible command-line JSON processor
* **[mas](https://github.com/mas-cli/mas)**: Mac App Store command-line interface
* **[navi](https://github.com/denisidoro/navi)**: Interactive cheatsheet tool for the command-line
* **[ripgrep](https://github.com/BurntSushi/ripgrep)**: Search tool like grep and The Silver Searcher
* **[tldr](https://tldr.sh/)**: Simplified and community-driven man pages
* **[tokei](https://github.com/XAMPPRocky/tokei)**: Program that allows you to count code, quickly
* **[tree](https://oldmanprogrammer.net/source.php?dir=projects/tree)**: Display directories as trees (with optional color/HTML output)
* **[tz](https://github.com/oz/tz)**: CLI time zone visualizer
* **[yq](https://github.com/mikefarah/yq)**: Process YAML documents from the CLI

### GUI Applications (Casks)

* **[1password](https://1password.com/)**: Password manager
* **[1password-cli](https://developer.1password.com/docs/cli/)**: Command-line interface for 1Password
* **[docker-desktop](https://www.docker.com/products/docker-desktop/)**: Build and share containerized applications
* **[font-hack-nerd-font](https://www.nerdfonts.com/)**: Developer targeted font with icons
* **[gitkraken](https://www.gitkraken.com/)**: Git client
* **[gitkraken-cli](https://help.gitkraken.com/cli/cli-home/)**: GitKraken Command Line Interface
* **[lens](https://k8slens.dev/)**: Kubernetes IDE
* **[microsoft-teams](https://www.microsoft.com/en-us/microsoft-teams)**: Team collaboration software
* **[raycast](https://www.raycast.com/)**: Control your tools with a few keystrokes
* **[setapp](https://setapp.com/)**: Collection of apps for macOS and iOS
* **[signal](https://signal.org/)**: Private messaging app
* **[slack](https://slack.com/)**: Team communication and collaboration software
* **[visual-studio-code](https://code.visualstudio.com/)**: Open-source code editor
* **[warp](https://www.warp.dev/)**: Modern, Rust-based terminal with AI built in
* **[arc](https://arc.net/)**: Web browser
* **[rectangle-pro](https://rectangleapp.com/pro)**: Window snapping tool
* **[betterdisplay](https://github.com/waydabber/BetterDisplay)**: Display management tool
* **[wins](https://wins.cool/)**: Bring your windows to your cursor
* **[adguard](https://adguard.com/)**: Ad blocker
* **[logi-options+](https://www.logitech.com/en-us/software/logi-options-plus.html)**: Software for Logitech devices
* **[aptakube](https://aptakube.com/)**: Modern Kubernetes GUI client
* **[orbstack](https://orbstack.dev/)**: Replacement for Docker Desktop
* **[postman](https://www.postman.com/)**: Collaboration platform for API development
* **[postman-cli](https://learning.postman.com/docs/postman-cli/postman-cli-overview/)**: Command-line companion for Postman
* **[apidog-europe](https://apidog.com/)**: All-in-one API development and testing tool

### Mac App Store Apps

* **[Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704)**: Keep-awake utility

### Libraries

* **[libyaml](https://pyyaml.org/wiki/LibYAML)**: YAML C library
* **[openssl@3](https://www.openssl.org/)**: Cryptography and SSL/TLS Toolkit

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
