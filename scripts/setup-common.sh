#!/usr/bin/env bash
# Common setup: frameworks, stow, and post-install steps (runs on all platforms)
# Each step is wrapped so a failure doesn't stop the rest of the script.

# ---------- zsh as default shell ----------
if ! command -v zsh &>/dev/null; then
    warn "zsh is not installed — skipping shell change (package install may have failed)"
elif [ "$SHELL" != "$(which zsh)" ]; then
    info "Setting zsh as default shell..."
    chsh -s "$(which zsh)" || warn "chsh failed — you may need to run: chsh -s \$(which zsh)"
else
    info "zsh is already the default shell"
fi

# ---------- Oh My Zsh ----------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    if sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
        ok "Oh My Zsh installed"
    else
        warn "Oh My Zsh install failed"
    fi
else
    info "Oh My Zsh is already installed"
fi

# ---------- zsh plugins ----------
# Uses parallel arrays instead of declare -A for bash 3.2 (macOS) compatibility
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    warn "Oh My Zsh is not installed — skipping zsh plugin installs"
else
    ZSH_PLUGIN_NAMES=(zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode)
    ZSH_PLUGIN_URLS=(
        "https://github.com/zsh-users/zsh-autosuggestions.git"
        "https://github.com/zsh-users/zsh-syntax-highlighting.git"
        "https://github.com/jeffreytse/zsh-vi-mode.git"
    )

    for i in "${!ZSH_PLUGIN_NAMES[@]}"; do
        plugin_name="${ZSH_PLUGIN_NAMES[$i]}"
        plugin_url="${ZSH_PLUGIN_URLS[$i]}"
        if [ ! -d "$ZSH_CUSTOM/plugins/$plugin_name" ]; then
            info "Installing $plugin_name..."
            if git clone "$plugin_url" "$ZSH_CUSTOM/plugins/$plugin_name"; then
                ok "$plugin_name installed"
            else
                warn "$plugin_name install failed (git clone from $plugin_url)"
            fi
        else
            info "$plugin_name is already installed"
        fi
    done
fi

# ---------- TPM (Tmux Plugin Manager) ----------
if ! command -v tmux &>/dev/null; then
    warn "tmux is not installed — skipping TPM install"
elif [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    if git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"; then
        ok "TPM installed"
    else
        warn "TPM install failed"
    fi
else
    info "TPM is already installed"
fi

# ---------- asdf version manager ----------
ASDF_AVAILABLE=false

if command -v brew &>/dev/null && brew list asdf &>/dev/null; then
    info "asdf is already installed via Homebrew"
    ASDF_AVAILABLE=true
elif [ -d "$HOME/.asdf" ]; then
    info "asdf is already installed"
    export ASDF_DIR="$HOME/.asdf"
    export PATH="$ASDF_DIR/bin:$ASDF_DIR/shims:$PATH"
    ASDF_AVAILABLE=true
else
    info "Installing asdf..."
    if git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.15.0; then
        export ASDF_DIR="$HOME/.asdf"
        export PATH="$ASDF_DIR/bin:$ASDF_DIR/shims:$PATH"
        ASDF_AVAILABLE=true
        ok "asdf installed"
    else
        warn "asdf install failed (git clone)"
    fi
fi

if $ASDF_AVAILABLE && ! command -v asdf &>/dev/null; then
    warn "asdf directory exists but 'asdf' command not available (check PATH)"
    ASDF_AVAILABLE=false
fi

# ---------- Stow dotfiles ----------
if ! command -v stow &>/dev/null; then
    warn "stow is not installed — skipping dotfile symlinking (package install may have failed)"
else
    mkdir -p "$HOME/.config"
    info "Stowing dotfile packages..."
    cd "$DOTFILES_DIR"
    for pkg in bash zsh vim tmux nvim; do
        info "  stow $pkg"
        if ! stow -v -d "$DOTFILES_DIR" -t "$HOME" --adopt "$pkg" 2>&1; then
            warn "stow $pkg failed"
        fi
    done
    info "Restoring dotfile versions after adopt..."
    git checkout -- .
fi

# ---------- Node.js via asdf ----------
if ! $ASDF_AVAILABLE; then
    warn "asdf not available — skipping Node.js install (asdf install failed earlier)"
else
    if ! asdf plugin list 2>/dev/null | grep -q nodejs; then
        info "Adding asdf nodejs plugin..."
        asdf plugin add nodejs || warn "Failed to add asdf nodejs plugin"
    fi

    NODEJS_VERSION="22.7.0"
    if ! asdf list nodejs 2>/dev/null | grep -q "$NODEJS_VERSION"; then
        info "Installing Node.js $NODEJS_VERSION via asdf..."
        if asdf install nodejs "$NODEJS_VERSION"; then
            ok "Node.js $NODEJS_VERSION installed"
        else
            warn "Failed to install Node.js $NODEJS_VERSION via asdf"
        fi
    fi
    asdf global nodejs "$NODEJS_VERSION" 2>/dev/null
fi

# ---------- cspell ----------
if ! command -v npm &>/dev/null; then
    warn "npm not available — skipping cspell install (Node.js may not have been installed)"
elif ! command -v cspell &>/dev/null; then
    info "Installing cspell..."
    if npm install -g cspell; then
        ok "cspell installed"
    else
        warn "cspell install failed"
    fi
else
    info "cspell is already installed"
fi

# ---------- gh-dash extension ----------
if ! command -v gh &>/dev/null; then
    warn "gh CLI not found — skipping gh-dash extension (package install may have failed)"
elif ! gh auth status &>/dev/null; then
    warn "gh is not authenticated — skipping gh-dash (run 'gh auth login' first)"
elif ! gh extension list 2>/dev/null | grep -q "dlvhdr/gh-dash"; then
    info "Installing gh-dash extension..."
    if gh extension install dlvhdr/gh-dash; then
        ok "gh-dash installed"
    else
        warn "gh-dash install failed"
    fi
else
    info "gh-dash is already installed"
fi
