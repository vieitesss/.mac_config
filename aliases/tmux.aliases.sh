#!/bin/sh

alias tks='tmux ls | sed "s/:.*//" | fzf | xargs tmux kill-session -t'
alias ts='tmux ls | sed "s/:.*//" | fzf | xargs tmux switch -t'
