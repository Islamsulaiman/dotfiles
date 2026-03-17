#!/usr/bin/env bash
# Removes everything installed by install.sh so you can re-run from a clean state.
# Does NOT remove: system packages (apt/brew), the dotfiles repo itself, git config, SSH keys.

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

info()  { printf "\033[1;34m[info]\033[0m  %s\n" "$1"; }
warn()  { printf "\033[1;33m[warn]\033[0m  %s\n" "$1"; }

echo ""
echo "This will remove:"
echo "  - Stow symlinks (~/.zshrc, ~/.bashrc, ~/.vimrc, ~/.tmux.conf, ~/.config/nvim)"
echo "  - Oh My Zsh (~/.oh-my-zsh)"
echo "  - TPM (~/.tmux/plugins)"
echo "  - asdf (~/.asdf)"
echo "  - zsh completion cache (~/.zcompdump*)"
echo "  - Node.js global packages (cspell)"
echo "  - gh-dash extension"
echo ""
echo "It will NOT remove: system packages, dotfiles repo, git config, SSH keys"
echo ""
printf "Continue? [y/N] "
read -r answer
if [[ ! "$answer" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Unstow all packages
info "Removing stow symlinks..."
cd "$DOTFILES_DIR"
for pkg in bash zsh vim tmux nvim; do
    stow -D "$pkg" 2>/dev/null && info "  unstowed $pkg" || true
done

# Remove Oh My Zsh (includes all plugins and themes)
if [ -d "$HOME/.oh-my-zsh" ]; then
    info "Removing Oh My Zsh..."
    rm -rf "$HOME/.oh-my-zsh"
fi

# Remove TPM and tmux plugins
if [ -d "$HOME/.tmux/plugins" ]; then
    info "Removing TPM and tmux plugins..."
    rm -rf "$HOME/.tmux/plugins"
fi

# Remove asdf (includes all plugins, runtimes, shims)
if [ -d "$HOME/.asdf" ]; then
    info "Removing asdf..."
    rm -rf "$HOME/.asdf"
fi

# Remove zsh completion cache
info "Removing zsh completion cache..."
rm -f "$HOME/.zcompdump"*

# Remove gh-dash extension
if command -v gh &>/dev/null && gh auth status &>/dev/null 2>&1; then
    if gh extension list 2>/dev/null | grep -q "dlvhdr/gh-dash"; then
        info "Removing gh-dash extension..."
        gh extension remove dlvhdr/gh-dash 2>/dev/null || true
    fi
fi

# Remove leftover config that Oh My Zsh or stow may have created
rm -f "$HOME/.zshrc" 2>/dev/null
rm -f "$HOME/.bashrc.pre-oh-my-zsh" 2>/dev/null

info "Clean state restored. You can now run ./install.sh again."
