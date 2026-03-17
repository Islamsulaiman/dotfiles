#!/usr/bin/env bash
# System package installation for macOS via Homebrew

if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode Command Line Tools (needed for treesitter)..."
    xcode-select --install
    warn "Xcode CLI tools install may require manual confirmation. Re-run this script after it finishes."
fi

PACKAGES=(
    git
    zsh
    neovim
    tmux
    fzf
    ripgrep
    fd
    lazygit
    gh
    stow
    curl
)

info "Installing Homebrew packages..."
for pkg in "${PACKAGES[@]}"; do
    if brew list "$pkg" &>/dev/null; then
        info "$pkg is already installed"
    else
        brew install "$pkg"
    fi
done
