if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# To add all path vars in bashrc and just source it in the zshrc without adding it in all environment
# source $HOME/.bashrc

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# plugins=(git zsh-z aliases history sudo zsh-syntax-highlighting zsh-autosuggestions)
plugins=(git z zsh-syntax-highlighting)

bindkey '^H' backward-kill-word

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi


[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# costum commands
export VISUAL=nvim
export EDITOR="$VISUAL"

alias open_gui="nautilus . &>/dev/null &"


# keychain for git ssh
eval "$(keychain --quiet --eval --agents ssh github_personal)"
eval "$(keychain --quiet --eval --agents ssh personal_gitlab)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"
