#!/usr/bin/env bash
# System package installation for Debian-based Linux (Ubuntu, Pop!_OS, etc.)

info "Updating apt package index..."
sudo apt update || warn "apt update failed"

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
    keychain
)

info "Installing apt packages..."
sudo apt install -y "${APT_PACKAGES[@]}" || warn "Some apt packages failed to install"

# fd is installed as fdfind on Debian — create a symlink so scripts can use 'fd'
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    info "Creating fd symlink for fdfind..."
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
fi

# lazygit is not in apt repos — install from GitHub releases
if ! command -v lazygit &>/dev/null; then
    info "Installing lazygit from GitHub releases..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    if [ -n "$LAZYGIT_VERSION" ]; then
        curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
            && sudo tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit \
            && rm /tmp/lazygit.tar.gz \
            || warn "lazygit install failed"
    else
        warn "Could not determine lazygit version — skipping"
    fi
else
    info "lazygit is already installed"
fi

# lazydocker is not in apt repos — install from GitHub releases
if ! command -v lazydocker &>/dev/null; then
    info "Installing lazydocker from GitHub releases..."
    LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    if [ -n "$LAZYDOCKER_VERSION" ]; then
        curl -Lo /tmp/lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz" \
            && sudo tar xf /tmp/lazydocker.tar.gz -C /usr/local/bin lazydocker \
            && rm /tmp/lazydocker.tar.gz \
            || warn "lazydocker install failed"
    else
        warn "Could not determine lazydocker version — skipping"
    fi
else
    info "lazydocker is already installed"
fi

# gh (GitHub CLI) — install from GitHub's official apt repo
if ! command -v gh &>/dev/null; then
    info "Installing GitHub CLI..."
    sudo mkdir -p -m 755 /etc/apt/keyrings \
        && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null \
        && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null \
        && sudo apt update \
        && sudo apt install -y gh \
        || warn "GitHub CLI install failed"
else
    info "gh is already installed"
fi
