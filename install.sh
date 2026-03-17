#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"

info()  { printf "\033[1;34m[info]\033[0m  %s\n" "$1"; }
warn()  { printf "\033[1;33m[warn]\033[0m  %s\n" "$1"; }
error() { printf "\033[1;31m[error]\033[0m %s\n" "$1"; exit 1; }

detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)
            if [ -f /etc/debian_version ]; then
                echo "debian"
            else
                error "Unsupported Linux distribution. Only Debian-based systems are supported."
            fi
            ;;
        *) error "Unsupported operating system: $(uname -s)" ;;
    esac
}

ask_yes_no() {
    local prompt="$1"
    local answer
    printf "%s [y/N] " "$prompt"
    read -r answer
    [[ "$answer" =~ ^[Yy]$ ]]
}

OS="$(detect_os)"
info "Detected OS: $OS"

info "Installing system packages..."
source "$SCRIPTS_DIR/packages-${OS}.sh"

info "Setting up frameworks and tools..."
INSTALL_RUBY=false
if ask_yes_no "Install Ruby tooling (asdf ruby plugin + ruby-lsp)?"; then
    INSTALL_RUBY=true
fi

source "$SCRIPTS_DIR/setup-common.sh"

info "Done! A few manual steps remain:"
echo "  1. Open a new terminal (or run 'exec zsh') to load the updated shell config"
echo "  2. Open tmux and press prefix+I (Ctrl-b then I) to install tmux plugins"
echo "  3. Open nvim — lazy.nvim will auto-install all plugins on first launch"
