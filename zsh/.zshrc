#!/usr/bin/env zsh
# Set PATH to default
PATH=$(tr "\n" ":" < "/etc/paths" | sed 's/.\{1\}$//')

export EDITOR="nvim"
DOTFILES="$HOME/.mac_config"
HOSTNAME=$(hostname)
TERM="screen-256color"
DISPLAY=$(ifconfig | grep -E "192\.168\.[0-9]{1,3}\.[0-9]{1,3}" | awk '{print $2}'):0.0
export BAT_THEME="OneHalfDark"

#########
# ZINIT #
#########

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zinit install
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light jeffreytse/zsh-vi-mode
zinit light Aloxaf/fzf-tab
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# completions setup
autoload -Uz compinit && compinit

zinit cdreplay -q

zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

# to rewrite keybindings
zvm_after_init () {
  # Edit line in vim with ctrl-e
  autoload -z edit-command-line
  zle -N edit-command-line
  bindkey "^x^e" edit-command-line

  bindkey -M viins "^u" end-of-line
  # bindkey "^n" history-search-forward
  # bindkey "^p" history-search-backward
  # bindkey -M viins "^[[1;5C" forward-word
  # bindkey -M viins "^[[1;5D" backward-word

  [ -f ~/.fzf.zsh ] && source "$HOME/.fzf.zsh"

  source <(fzf --zsh)
  source $(brew --cellar fzf)/**/key-bindings.zsh
}

# zsh vi mode
export ZVM_VI_INSERT_ESCAPE_BINDKEY=nk
export ZVM_INSERT_MODE_CURSOR='bl'

###########
# OPTIONS #
###########

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=$HISTSIZE
HIISTDUP=erase
setopt autocd notify
setopt append_history
setopt extended_glob
setopt share_history
setopt inc_append_history
unsetopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_verify
setopt hist_reduce_blanks
unsetopt beep extendedglob nomatch

source "$HOME/.zsh_functions"

# add-to-path "JAVA_HOME" "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home" "bin"
# add-to-path "OPENSSL_HOME" "/usr/local/opt/openssl@3.0" "bin"
# add-to-path "PET_HOME" "$HOME/pet"
add-to-path "MY_SCRIPTS" "$HOME/.mac_config/scripts"
test "$(uname -p)" == "arm" && add-to-path "HOMEBREW" "/opt/homebrew" "/bin" || add-to-path "HOMEBREW" "/usr/local/Homebrew" "/bin"
add-to-path "LTX_HOME" "/Library/TeX" "/texbin"
add-to-path "LOCAL_BIN" "$HOME/.local/bin"
add-to-path "CARGO_HOME" "$HOME/.cargo" "/bin"


export PATH

source_folder "$DOTFILES/aliases"
source_folder "$HOME/obsidian/terminal"

source "$HOME/.cargo/env"
# source "$HOME/.aws-tokens"

# export STARSHIP_CONFIG=~/.config/starship/starship.toml
export FZF_DEFAULT_OPTS='--preview "bat --style=numbers --color=always --line-range :500 {}"'
export FZF_DEFAULT_COMMAND='fd --hidden --exclude .git'
export FZF_CTRL_T_COMMAND='fd --hidden'
export FZF_ALT_C_COMMAND='fd --hidden'

# eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

source $(brew --cellar fzf)/**/key-bindings.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
