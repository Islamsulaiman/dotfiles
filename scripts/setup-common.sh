#!/usr/bin/env bash
# Common setup: frameworks, stow, and post-install steps (runs on all platforms)
# Each step is wrapped so a failure doesn't stop the rest of the script.

# ---------- zsh as default shell ----------
if [ "$SHELL" != "$(which zsh)" ]; then
    info "Setting zsh as default shell..."
    chsh -s "$(which zsh)" || warn "chsh failed — you may need to run: chsh -s \$(which zsh)"
else
    info "zsh is already the default shell"
fi

# ---------- Oh My Zsh ----------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || warn "Oh My Zsh install failed"
else
    info "Oh My Zsh is already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ---------- zsh plugins ----------
declare -A ZSH_PLUGINS=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    ["zsh-vi-mode"]="https://github.com/jeffreytse/zsh-vi-mode.git"
)

for plugin_name in "${!ZSH_PLUGINS[@]}"; do
    if [ ! -d "$ZSH_CUSTOM/plugins/$plugin_name" ]; then
        info "Installing $plugin_name..."
        git clone "${ZSH_PLUGINS[$plugin_name]}" "$ZSH_CUSTOM/plugins/$plugin_name" || warn "$plugin_name install failed"
    else
        info "$plugin_name is already installed"
    fi
done

# ---------- TPM (Tmux Plugin Manager) ----------
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm" || warn "TPM install failed"
else
    info "TPM is already installed"
fi

# ---------- asdf version manager ----------
if command -v brew &>/dev/null && brew list asdf &>/dev/null; then
    info "asdf is already installed via Homebrew"
    # shellcheck source=/dev/null
    . "$(brew --prefix asdf)/libexec/asdf.sh" 2>/dev/null
elif [ -d "$HOME/.asdf" ]; then
    info "asdf is already installed"
    export ASDF_DIR="$HOME/.asdf"
    # shellcheck source=/dev/null
    . "$ASDF_DIR/asdf.sh" 2>/dev/null
else
    info "Installing asdf..."
    if git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.15.0; then
        export ASDF_DIR="$HOME/.asdf"
        # shellcheck source=/dev/null
        . "$ASDF_DIR/asdf.sh" 2>/dev/null
    else
        warn "asdf install failed"
    fi
fi

# ---------- Stow dotfiles ----------
# --adopt: if a target file already exists as a real file (not a symlink),
# stow moves it into the package dir and creates the symlink. We then
# git checkout to get our dotfiles version back (not the adopted file).
info "Stowing dotfile packages..."
cd "$DOTFILES_DIR"
for pkg in bash zsh vim tmux nvim; do
    info "  stow $pkg"
    if ! stow -v --adopt --restow "$pkg" 2>&1; then
        warn "  stow $pkg failed"
    fi
done
info "Restoring dotfile versions after adopt..."
git checkout -- .

# ---------- Node.js via asdf ----------
if command -v asdf &>/dev/null; then
    if ! asdf plugin list 2>/dev/null | grep -q nodejs; then
        info "Adding asdf nodejs plugin..."
        asdf plugin add nodejs || warn "Failed to add nodejs plugin"
    fi

    NODEJS_VERSION="22.7.0"
    if ! asdf list nodejs 2>/dev/null | grep -q "$NODEJS_VERSION"; then
        info "Installing Node.js $NODEJS_VERSION via asdf..."
        asdf install nodejs "$NODEJS_VERSION" || warn "Failed to install Node.js"
    fi
    asdf global nodejs "$NODEJS_VERSION" 2>/dev/null
else
    warn "asdf not available — skipping Node.js install"
fi

# ---------- cspell ----------
if command -v npm &>/dev/null; then
    if ! command -v cspell &>/dev/null; then
        info "Installing cspell..."
        npm install -g cspell || warn "cspell install failed"
    else
        info "cspell is already installed"
    fi
else
    warn "npm not available — skipping cspell install"
fi

# ---------- gh-dash extension ----------
if command -v gh &>/dev/null; then
    if gh auth status &>/dev/null; then
        if ! gh extension list 2>/dev/null | grep -q "dlvhdr/gh-dash"; then
            info "Installing gh-dash extension..."
            gh extension install dlvhdr/gh-dash || warn "gh-dash install failed"
        else
            info "gh-dash is already installed"
        fi
    else
        warn "gh is not authenticated — skipping gh-dash (run 'gh auth login' first)"
    fi
else
    warn "gh CLI not found — skipping gh-dash extension"
fi
