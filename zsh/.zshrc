# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd notify
unsetopt beep extendedglob nomatch
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
# END OF LINES ADDED BY COMPINSTALL

# vi mode
bindkey -v
export KEYTIMEOUT=30

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Edit line in vim with ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# CONFIG
export DOTFILES="$HOME/.mac_config"
export HOSTNAME=$(hostname)
export TERM="screen-256color"
export DISPLAY=$(ifconfig | egrep "192\.168\.[0-9]{1,3}\.[0-9]{1,3}" | awk '{print $2}'):0.0

# Bat
export BAT_THEME="OneHalfDark"

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

source "$DOTFILES/aliases/general.aliases.sh"
source "$DOTFILES/aliases/git.aliases.sh"
source "$DOTFILES/aliases/docker.aliases.sh"
source "$DOTFILES/aliases/tmux.aliases.sh"
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/sudo.plugin.zsh"
source "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
# source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

source "$HOME/.cargo/env"

# if [[ ! -z $(which colorscript) ]]; then
#     colorscript random
# fi

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
# bindkey '^j' autosuggest-accept
# bindkey '^u' end-of-line
# bindkey '^ ' autosuggest-accept

[ -f ~/.fzf.zsh ] && source "$HOME/.fzf.zsh"

export FZF_DEFAULT_COMMAND="find ."
# export FZF_CTRL_T_COMMAND="find ."
export FZF_TMUX_OPTS="-p"
export FZF_CTRL_T_OPTS="--reverse --preview 'bat {} --color=always'"

# precmd () {print -Pn "\e]0;%~\a"}
alias luamake="\$HOME/lua-language-server/3rd/luamake/luamake"
export PATH="/usr/local/opt/llvm/bin:$PATH"

export EDITOR="nvim"

# zsh vi mode
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_INSERT_MODE_CURSOR='bl'

# if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
#     zvm_bindkey viins '^U' end-of-line
# fi

# ~/.tmux/scripts/init.sh
# bun
export BUN_INSTALL="$HOME/Library/Application Support/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

source "$HOME/.aoc"

# tput cup 9999 0
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
