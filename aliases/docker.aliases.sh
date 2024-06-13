#!/bin/bash

dockerComposeDownContainer () {
 cd "$(docker-compose ls -a | tail -n +2 | awk '{print $3}' | fzf | sed 's#/[^/]*$##')" && docker-compose down -t 0
}
alias dcdc=dockerComposeDownContainer

alias dcu='docker compose up'
alias dps='docker ps'
alias dcl='docker compose logs'
alias dcd='docker compose down'
alias de='docker exec'

alias kc='kubectl'
alias kcg='kubectl get'
alias kca='kubectl apply'
alias kcd='kubectl delete'
