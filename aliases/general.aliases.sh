#!/usr/bin/env bash

# List directory contents
alias ls="ls --color"
alias ll="eza --long --group-directories-first --icons --no-time"
alias le="eza --group-directories-first --icons"
alias leg="eza --long --git --group-directories-first --icons --no-time --no-user --no-permissions --no-filesize"
alias lt="eza -T --icons"
alias ltl="eza -T --long --icons --no-time"
# alias sl=ls
alias la="eza -al --group-directories-first"
alias tree="eza --tree"

copy () {
	cat "$1" | pbcopy
}

install () {
	cmd="just -f $HOME/.mac_config/justfile"
	test "$#" -gt 0 && cmd="$cmd ${@:1}"
	bash -c "$cmd"
}
alias remove="sudo apt remove"
alias purge="sudo apt purge"
alias dot="cd \$DOTFILES"
alias obs="cd ~/obsidian"
alias pro="cd ~/projects/"

# bat
alias bat="bat --decorations=never --paging=never"
alias batn="bat -n"
alias batnl="bat -p"

# Shortcuts to edit startup files
alias vbrc="vim ~/.bashrc"
alias vrc="vim ~/.config/nvim/init.lua"
alias nvd="cd ~/.config/nvim/"

# c makefile
alias makec="make -f ~/.mac_config/makefiles/c/Makefile"

# convert png to jpg
convertToJpg() {
    for i in "$@"; do
        magick "$i" "${i%.*}.jpg"
    done
}

# ripgrep edit
rgv() {
    rg --hidden --vimgrep "$1" | fzf --bind "Enter:become(echo {1})" | awk -F : '{print "nvim " $1 " +" $2}' | zsh
}

# aliases
alias falias="alias | fzf"

# ovftool
alias ovftool="/usr/bin/vmware-ovftool/ovftool"

#source
alias s="source ~/.zshrc"

# theme
dark() {
    kitty +kitten themes --reload-in=all Gruvbox Dark
    export BAT_THEME="gruvbox-dark"
}

light() {
    kitty +kitten themes --reload-in=all Gruvbox Light
    export BAT_THEME="gruvbox-light"
}

take() {
    mkdir -p "$1"
    cd "$1" || exit
}

paneName() {
    tmux select-pane -T "$1"
}

pacs() {
    find "$(echo "$PATH" | tr ':' ' ')" | sed -e '/\/.*/d' -e '/^$/d' | fzf --preview="tldr {}" --ansi
}

#clear
alias c="clear"
alias k="clear"
alias cls="clear"
# alias clear='clear && tput cup 9999 0'

# find process with fzf and kill it
fkill() {
    ps ax | awk '{print $5}' | tail -n +2 | fzf | xargs kill -9
}

# export EDITOR="nvim"
alias edit="\$EDITOR"
alias pager="\$PAGER"

alias q="exit"

alias irc="\${IRC_CLIENT:=irc}"

# Language aliases
alias j="java"
alias py="/usr/local/bin/python3"
alias gcc="gcc-12"

# jupyter notebook
alias notebook="python3 -m notebook"

# Pianobar can be found here: http://github.com/PromyLOPh/pianobar/

alias piano="pianobar"

alias ..="cd .."         # Go up one directory
alias cd..="cd .."       # Common misspelling for going up one directory
alias ...="cd ../.."     # Go up two directories
alias ....="cd ../../.." # Go up three directories
alias -- -="cd -"        # Go back

# Shell History
alias h="history"

# Directory
alias md="mkdir -p"
alias rd="rmdir"

# Shorten extract
alias xt="extract"

# editors
alias v=nvim
# alias vim=nvim
alias e=emacs

# sudo editors
alias svim="sudo vim"
alias snano="sudo nano"

# Display whatever file is regular file or folder
catt() {
    for i in "$@"; do
        if [ -d "$i" ]; then
            ls "$i"
        else
            cat "$i"
        fi
    done
}

# The Bash-it aliases were moved to the `bash-it.aliases.bash` file. The intent of this
# is to keep the script readable and less bloated. If you don't need to use
# the `general` aliases, but you want the Bash-it aliases, you can disable the `general`
# aliases and enable just the ones for Bash-it explicitly:
# bash-it disable alias general
# bash-it enable alias bash-it
# shellcheck source=./bash-it.aliases.bash
#source "$BASH_IT/aliases/available/bash-it.aliases.bash"
alias lazygit="go run /opt/lazygit/main.go"
