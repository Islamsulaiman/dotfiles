#!/usr/bin/env bash
# System package installation for macOS via Homebrew

if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        ok "Homebrew installed"
    else
        warn "Homebrew install failed — cannot install packages"
        return 1 2>/dev/null || exit 1
    fi
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
    lazydocker
    gh
    stow
    curl
    asdf
)

info "Installing Homebrew packages..."
for pkg in "${PACKAGES[@]}"; do
    if brew list "$pkg" &>/dev/null; then
        info "$pkg is already installed"
    else
        if brew install "$pkg"; then
            ok "$pkg installed"
        else
            warn "brew install $pkg failed"
        fi
    fi
done
