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

# options
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

# CONFIG
DOTFILES="$HOME/.mac_config"
export DOTFILES
HOSTNAME=$(hostname)
export HOSTNAME
export TERM="screen-256color"
DISPLAY=$(ifconfig | grep -E "192\.168\.[0-9]{1,3}\.[0-9]{1,3}" | awk '{print $2}'):0.0
export DISPLAY

# Bat
export BAT_THEME="OneHalfDark"

# Alacritty themes
function alacritty-themes() {
  docker run --rm -it -v "$HOME/.config/alacritty:/app/alacritty" vieitesss/alacritty-themes
}

if [[ -d /opt/jdk-11.0.13 ]]; then
    export JAVA_HOME="/opt/jdk-11.0.13"
    PATH="$JAVA_HOME/bin:$PATH"
fi

if [[ -d /opt/ltex-ls-15.2.0 ]]; then
    export LTEX_HOME="/opt/ltex-ls-15.2.0"
    PATH="$LTEX_HOME/bin:$PATH"
fi

if [[ -d /usr/local/go ]]; then
    export GO_HOME="/usr/local/go"
    PATH="$GO_HOME/bin:$PATH"
fi

export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home/"
PATH="$JAVA_HOME:$PATH"

export M2_HOME="/Users/vieites/apache-maven-3.9.5"
PATH="$M2_HOME/bin:$PATH"

export POSTGRESQL="/Library/Java/Extensions/postgresql-42.5.2.jar"
PATH="$POSTGRESQL:$PATH"

PATH="/bin:/usr/bin:/usr/local/bin:$PATH"

export PATH

# C LIBS
export CPATH=$HOME/uni/2/coga/practicas/lib/glad/include_lib:/usr/local/Cellar/freetype/2.13.0_1/include/freetype2

function source_folder() {
  # source every file inside the folder passed as argument, depth 1
  for file in "$1"/*; do
    if [[ -f "$file" ]]; then
      source "$file"
    fi
  done
}

source_folder "$DOTFILES/aliases"
source_folder "$HOME/obsidian/terminal"

source "$HOME/.cargo/env"

# if [[ ! -z $(which colorscript) ]]; then
#     colorscript random
# fi

# export FZF_DEFAULT_COMMAND="find ."
# export FZF_CTRL_T_COMMAND="find ."
# export FZF_TMUX_OPTS="-p"
# export FZF_CTRL_T_OPTS="--reverse --preview 'bat {}'"
# export FZF_CTRL_R_OPTS=""
# export FZF_TMUX=1
# export FZF_TMUX_OPTS=''

alias luamake="\$HOME/lua-language-server/3rd/luamake/luamake"
export PATH="/usr/local/opt/llvm/bin:$PATH"

export EDITOR="nvim"

# zsh vi mode
export ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
export ZVM_INSERT_MODE_CURSOR='bl'
# Change to Zsh's default readkey engine
# export ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_ZLE

# ~/.tmux/scripts/init.sh
export BUN_INSTALL="$HOME/Library/Application Support/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/usr/local/opt/openssl@3.0/bin:$PATH"

# source "$HOME/.aoc"

# eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
