#!/usr/bin/env bash
# System package installation for Debian-based Linux (Ubuntu, Pop!_OS, etc.)

info "Updating apt package index..."
sudo apt update

APT_PACKAGES=(
    git
    zsh
    neovim
    tmux
    fzf
    ripgrep
    fd-find
    stow
    curl
    xclip
    build-essential
)

info "Installing apt packages..."
sudo apt install -y "${APT_PACKAGES[@]}"

# fd is installed as fdfind on Debian — create a symlink so scripts can use 'fd'
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    info "Creating fd symlink for fdfind..."
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
fi

# lazygit is not in apt repos — install from GitHub releases
if ! command -v lazygit &>/dev/null; then
    info "Installing lazygit from GitHub releases..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    sudo tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit
    rm /tmp/lazygit.tar.gz
else
    info "lazygit is already installed"
fi

# gh (GitHub CLI) — install from GitHub's official apt repo
if ! command -v gh &>/dev/null; then
    info "Installing GitHub CLI..."
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt update
    sudo apt install -y gh
else
    info "gh is already installed"
fi
