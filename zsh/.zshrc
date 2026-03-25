# ==============================================================================
# 1. ENVIRONMENT VARIABLES
# ==============================================================================
export EDITOR="nvim"
export VISUAL="nvim"
export CODEBASE="$HOME/code"
export DISABLE_SPRING=1

# ==============================================================================
# 2. PATH & ASDF CONFIGURATION
# ==============================================================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.console-ninja/.bin:$PATH"

if [[ "$(uname)" == "Darwin" ]]; then
    export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
fi

# asdf: brew install sources it automatically; git clone needs manual sourcing
if [[ -f "$HOME/.asdf/asdf.sh" ]]; then
    . "$HOME/.asdf/asdf.sh"
    . "$HOME/.asdf/completions/asdf.bash" 2>/dev/null
fi
export PATH="$HOME/.asdf/shims:$PATH"

# ==============================================================================
# 3. OH MY ZSH CONFIGURATION
# ==============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-vi-mode
)

# Remove vendor-completions from fpath if it contains broken symlinks
# (fixes Docker completion error on WSL/Pop!_OS where _docker is a broken symlink)
if [[ -L /usr/share/zsh/vendor-completions/_docker && ! -e /usr/share/zsh/vendor-completions/_docker ]]; then
    fpath=("${fpath[@]:#/usr/share/zsh/vendor-completions}")
fi

source "$ZSH/oh-my-zsh.sh"

# ==============================================================================
# 4. CUSTOM BINDINGS & COMPLETIONS
# ==============================================================================
bindkey '^H' backward-kill-word
bindkey '\033\x7f' backward-kill-word

[[ -f "$HOME/.pybritive-complete.zsh" ]] && source "$HOME/.pybritive-complete.zsh"

# ==============================================================================
# 5. ALIASES
# ==============================================================================
if [[ "$(uname)" == "Darwin" ]]; then
    alias open_gui="open ."
else
    alias open_gui="nautilus . &>/dev/null &"
fi

# ==============================================================================
# 6. SSH / KEYCHAIN
# ==============================================================================
if [[ "$(uname)" == "Darwin" ]]; then
    ssh-add --apple-use-keychain ~/.ssh/github 2>/dev/null
else
    if command -v keychain &>/dev/null; then
        eval "$(keychain --quiet --eval --agents ssh github 2>/dev/null)"
    fi
fi

# ==============================================================================
# 7.  LOAD MACHINE-SPECIFIC SETTINGS AND PATHS IF THERES ANY
# ==============================================================================

if [[ -f ~/.zshrc.local ]]; then
      source ~/.zshrc.local
fi
