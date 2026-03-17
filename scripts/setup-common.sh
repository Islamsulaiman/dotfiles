#!/usr/bin/env bash
# Common setup: frameworks, stow, and post-install steps (runs on all platforms)

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    info "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
else
    info "zsh is already the default shell"
fi

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    info "Oh My Zsh is already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    info "zsh-autosuggestions is already installed"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    info "zsh-syntax-highlighting is already installed"
fi

# zsh-vi-mode
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]; then
    info "Installing zsh-vi-mode..."
    git clone https://github.com/jeffreytse/zsh-vi-mode.git "$ZSH_CUSTOM/plugins/zsh-vi-mode"
else
    info "zsh-vi-mode is already installed"
fi

# TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    info "TPM is already installed"
fi

# asdf version manager
if command -v brew &>/dev/null && brew list asdf &>/dev/null; then
    info "asdf is already installed via Homebrew"
    # shellcheck source=/dev/null
    . "$(brew --prefix asdf)/libexec/asdf.sh"
elif [ -d "$HOME/.asdf" ]; then
    info "asdf is already installed"
    export ASDF_DIR="$HOME/.asdf"
    # shellcheck source=/dev/null
    . "$ASDF_DIR/asdf.sh"
else
    info "Installing asdf..."
    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch v0.15.0
    export ASDF_DIR="$HOME/.asdf"
    # shellcheck source=/dev/null
    . "$ASDF_DIR/asdf.sh"
fi

# Stow dotfiles
# --adopt: if a target file already exists as a real file (not a symlink),
# stow moves it into the package dir and creates the symlink. We then
# git restore to get our dotfiles version back (not the adopted file).
info "Stowing dotfile packages..."
cd "$DOTFILES_DIR"
for pkg in bash zsh vim tmux nvim; do
    info "  stow $pkg"
    stow -v --adopt --restow "$pkg" 2>&1 | while read -r line; do
        info "    $line"
    done
done
info "Restoring dotfile versions after adopt..."
git checkout -- .

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
