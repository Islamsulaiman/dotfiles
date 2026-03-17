#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"

info()  { printf "\033[1;34m[info]\033[0m  %s\n" "$1"; }
warn()  { printf "\033[1;33m[warn]\033[0m  %s\n" "$1"; }
error() { printf "\033[1;31m[error]\033[0m %s\n" "$1"; }

run_step() {
    local step_name="$1"
    shift
    info "--- $step_name ---"
    if "$@"; then
        info "$step_name completed"
    else
        warn "$step_name FAILED (exit code $?) — continuing with remaining steps"
    fi
}

detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)
            if [ -f /etc/debian_version ]; then
                echo "debian"
            else
                error "Unsupported Linux distribution. Only Debian-based systems are supported."
                exit 1
            fi
            ;;
        *)
            error "Unsupported operating system: $(uname -s)"
            exit 1
            ;;
    esac
}

OS="$(detect_os)"
info "Detected OS: $OS"

info "Installing system packages..."
source "$SCRIPTS_DIR/packages-${OS}.sh"

info "Setting up frameworks and tools..."
source "$SCRIPTS_DIR/setup-common.sh"

info "Done! A few manual steps remain:"
echo "  1. Log out and back in (or run 'exec zsh') to load the updated shell config"
echo "  2. Open tmux and press prefix+I (Ctrl-b then I) to install tmux plugins"
echo "  3. Open nvim — lazy.nvim will auto-install all plugins on first launch"
