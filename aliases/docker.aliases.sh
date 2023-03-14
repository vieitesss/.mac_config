#!/bin/sh

dockerComposeDown () {
 cd $(docker-compose ls -a | tail -n +2 | awk '{print $3}' | fzf | sed 's#/[^/]*$##') && docker-compose down -t 0
}
alias dcd=dockerComposeDown

alias dcu='docker-compose up -d'
alias dps='docker ps'
