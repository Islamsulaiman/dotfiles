#!/usr/bin/env bash
# Common setup: frameworks, stow, and post-install steps (runs on all platforms)

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    info "Oh My Zsh is already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Powerlevel10k
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    info "Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
    info "Powerlevel10k is already installed"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    info "zsh-syntax-highlighting is already installed"
fi

# TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    info "TPM is already installed"
fi

# asdf version manager
if [ ! -d "$HOME/.asdf" ]; then
    info "Installing asdf..."
    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.14.0
else
    info "asdf is already installed"
fi

# Source asdf so we can use it in subsequent steps
export ASDF_DIR="$HOME/.asdf"
# shellcheck source=/dev/null
. "$ASDF_DIR/asdf.sh"

# Stow dotfiles
info "Stowing dotfile packages..."
cd "$DOTFILES_DIR"
for pkg in bash zsh vim tmux nvim; do
    info "  stow $pkg"
    stow -v --restow "$pkg" 2>&1 | while read -r line; do
        info "    $line"
    done
done

# Node.js via asdf
if ! asdf plugin list 2>/dev/null | grep -q nodejs; then
    info "Adding asdf nodejs plugin..."
    asdf plugin add nodejs
fi

NODEJS_VERSION="22.7.0"
if ! asdf list nodejs 2>/dev/null | grep -q "$NODEJS_VERSION"; then
    info "Installing Node.js $NODEJS_VERSION via asdf..."
    asdf install nodejs "$NODEJS_VERSION"
fi
asdf global nodejs "$NODEJS_VERSION"

# cspell
if ! command -v cspell &>/dev/null; then
    info "Installing cspell..."
    npm install -g cspell
else
    info "cspell is already installed"
fi

# gh-dash extension
if command -v gh &>/dev/null; then
    if ! gh extension list 2>/dev/null | grep -q "dlvhdr/gh-dash"; then
        info "Installing gh-dash extension..."
        gh extension install dlvhdr/gh-dash
    else
        info "gh-dash is already installed"
    fi
else
    warn "gh CLI not found — skipping gh-dash extension"
fi

# Ruby (optional)
if [ "$INSTALL_RUBY" = true ]; then
    if ! asdf plugin list 2>/dev/null | grep -q ruby; then
        info "Adding asdf ruby plugin..."
        asdf plugin add ruby
    fi

    if ! asdf list ruby 2>/dev/null | grep -q "latest"; then
        info "Installing latest Ruby via asdf (this may take a while)..."
        asdf install ruby latest
        asdf global ruby latest
    fi

    if ! command -v ruby-lsp &>/dev/null; then
        info "Installing ruby-lsp gem..."
        gem install ruby-lsp
    else
        info "ruby-lsp is already installed"
    fi
fi
