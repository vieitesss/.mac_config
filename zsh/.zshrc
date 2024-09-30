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

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# to rewrite keybindings
function zvm_after_init() {
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
}

# zsh vi mode
export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
export ZVM_INSERT_MODE_CURSOR='bl'

###########
# OPTIONS #
###########

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=$HISTSIZE
HIISTDUP=erase
setopt autocd notify
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
unsetopt beep extendedglob nomatch

#############
# FUNCTIONS #
#############

# Alacritty themes
function alacritty-themes {
  docker run --rm -it -v "$HOME/.config/alacritty:/app/alacritty" vieitesss/alacritty-themes
}

# Add home variable and includes into the path
# $1 -> home name, to name env variable
# $2 -> home dir, to save into the env variable
# $3 -> inner dir to add to the path instead of the home dir
function add-to-path {
  if [[ ! -d "$2" ]]; then
    echo "The path $2 does not exist"
    return 1
  fi

  export "$1"="$2"

  if [[ -z "$3" ]]; then
    PATH="$1:$PATH"
  elif [[ -d "$2/$3" ]]; then
    PATH="$2/$3:$PATH"
  else
    "The path $2/$3 does not exist"
  fi
}

# Source every file inside the folder passed as argument, depth 1
# $1 -> The path to de folder
function source_folder {
  for file in "$1"/*; do
    if [[ -f "$file" ]]; then
      source "$file"
    fi
  done
}

add-to-path "JAVA_HOME" "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home" "bin"
add-to-path "OPENSSL_HOME" "/usr/local/opt/openssl@3.0" "bin"

export PATH

source_folder "$DOTFILES/aliases"
source_folder "$HOME/obsidian/terminal"

source "$HOME/.cargo/env"
source "$HOME/.aws-tokens"

# eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
