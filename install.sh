#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"

FAILURES=()

info()  { printf "\033[1;34m[info]\033[0m  %s\n" "$1"; }
ok()    { printf "\033[1;32m[ ok ]\033[0m  %s\n" "$1"; }
warn()  { printf "\033[1;33m[warn]\033[0m  %s\n" "$1"; FAILURES+=("$1"); }
error() { printf "\033[1;31m[error]\033[0m %s\n" "$1"; FAILURES+=("$1"); }

print_summary() {
    echo ""
    echo "==========================================="
    if [ ${#FAILURES[@]} -eq 0 ]; then
        ok "All steps completed successfully!"
    else
        printf "\033[1;31m%d failure(s) detected:\033[0m\n" "${#FAILURES[@]}"
        echo ""
        local i=1
        for msg in "${FAILURES[@]}"; do
            printf "  \033[1;31m%d.\033[0m %s\n" "$i" "$msg"
            i=$((i + 1))
        done
        echo ""
        echo "Review the output above for details, then re-run after fixing."
    fi
    echo "==========================================="
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

print_summary

echo ""
info "Manual steps:"
echo "  1. Log out and back in (or run 'exec zsh') to load the updated shell config"
echo "  2. Open tmux and press prefix+I (Ctrl-b then I) to install tmux plugins"
echo "  3. Open nvim — lazy.nvim will auto-install all plugins on first launch"
echo "  4. Run 'gh auth login' to authenticate GitHub CLI, then gh-dash will work"
