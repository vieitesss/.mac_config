#!/usr/bin/env zsh

prefapp() {
    local profile="${1:-prefapp-admin}"
    aws sso login --profile "$profile" >/dev/null
    eval "$(aws configure export-credentials --profile "$profile" --format env)"
    echo "Loaded profile $profile credentials"
}

_prefapp_complete() {
    local -a profiles
    profiles=("${(@f)$(grep '^\[profile ' ~/.aws/config | sed -E 's/^\[profile ([^]]+)\]/\1/')}")
    compadd "$@" -- $profiles
}

  compdef _prefapp_complete prefapp
