#!/usr/bin/env bash
# System package installation for Debian-based Linux (Ubuntu, Pop!_OS, etc.)

info "Updating apt package index..."
sudo apt update || warn "apt update failed — package installs may fail"

APT_PACKAGES=(
    git
    zsh
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
if sudo apt install -y "${APT_PACKAGES[@]}"; then
    ok "apt packages installed"
else
    warn "Some apt packages failed to install"
fi

# Verify critical apt packages are available
for cmd in git zsh tmux stow curl; do
    if ! command -v "$cmd" &>/dev/null; then
        warn "$cmd is not available after apt install — downstream steps may fail"
    fi
done

# neovim — apt version is too old for LazyVim, install from GitHub releases
if ! command -v nvim &>/dev/null; then
    info "Installing neovim from GitHub releases..."
    NVIM_VERSION=$(curl -s "https://api.github.com/repos/neovim/neovim/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
    if [ -n "$NVIM_VERSION" ]; then
        if curl -Lo /tmp/nvim-linux-x86_64.tar.gz "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz" \
            && sudo rm -rf /opt/nvim-linux-x86_64 \
            && sudo tar xf /tmp/nvim-linux-x86_64.tar.gz -C /opt \
            && sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim \
            && rm /tmp/nvim-linux-x86_64.tar.gz; then
            ok "neovim $NVIM_VERSION installed"
        else
            warn "neovim install failed (download or extraction error)"
        fi
    else
        warn "Could not determine neovim version from GitHub API — skipping"
    fi
else
    info "neovim is already installed ($(nvim --version | head -1))"
fi

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
        if curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
            && sudo tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit \
            && rm /tmp/lazygit.tar.gz; then
            ok "lazygit $LAZYGIT_VERSION installed"
        else
            warn "lazygit install failed (download or extraction error)"
        fi
    else
        warn "Could not determine lazygit version from GitHub API — skipping"
    fi
else
    info "lazygit is already installed"
fi

# lazydocker is not in apt repos — install from GitHub releases
if ! command -v lazydocker &>/dev/null; then
    info "Installing lazydocker from GitHub releases..."
    LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    if [ -n "$LAZYDOCKER_VERSION" ]; then
        if curl -Lo /tmp/lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz" \
            && sudo tar xf /tmp/lazydocker.tar.gz -C /usr/local/bin lazydocker \
            && rm /tmp/lazydocker.tar.gz; then
            ok "lazydocker $LAZYDOCKER_VERSION installed"
        else
            warn "lazydocker install failed (download or extraction error)"
        fi
    else
        warn "Could not determine lazydocker version from GitHub API — skipping"
    fi
else
    info "lazydocker is already installed"
fi

# Fix broken Docker completion symlink (common on WSL)
if [ -L /usr/share/zsh/vendor-completions/_docker ] && [ ! -e /usr/share/zsh/vendor-completions/_docker ]; then
    info "Removing broken Docker completion symlink..."
    sudo rm -f /usr/share/zsh/vendor-completions/_docker || warn "Could not remove broken Docker completion symlink"
fi

# gh (GitHub CLI) — install from GitHub's official apt repo
if ! command -v gh &>/dev/null; then
    info "Installing GitHub CLI..."
    if sudo mkdir -p -m 755 /etc/apt/keyrings \
        && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null \
        && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null \
        && sudo apt update \
        && sudo apt install -y gh; then
        ok "GitHub CLI installed"
    else
        warn "GitHub CLI install failed"
    fi
else
    info "gh is already installed"
fi
