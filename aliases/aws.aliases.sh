#!/usr/bin/env zsh

prefapp() {
    # catch sigterm and sigint to avoid leaving temp files around
    trap 'echo "[info] exiting..."; return 1' SIGTERM SIGINT

    local profile="${1:-prefapp-admin}"
    echo -n "[info] Logging in to AWS profile: $profile ..."
    aws sso login --profile "$profile" >/dev/null
    echo -e "\r[info] Logged in to AWS SSO for profile $profile ✅"
    echo -n "[info] Exporting AWS credentials ..."
    eval "$(aws configure export-credentials --profile "$profile" --format env)"
    echo -e "\r[info] Exported AWS credentials for profile $profile ✅"
    if [[ $? -ne 0 ]]; then
        echo -e "[error] Failed to export credentials for profile $profile"
        return 1
    fi

    local cluster
    cluster=$(aws eks list-clusters --profile "$profile" --query "clusters[0]" --output text)
    if [[ -z "$cluster" || "$cluster" == "None" ]]; then
        echo -e "[info] No EKS clusters found for profile $profile"
        echo -e "[info] Set the EKS cluster manually using 'aws eks update-kubeconfig --name <cluster-name> --profile $profile'"
        return 1
    fi

    echo -e "[info] Loaded profile $profile credentials"
}

_prefapp_complete() {
    local -a profiles
    profiles=("${(@f)$(grep '^\[profile ' ~/.aws/config | sed -E 's/^\[profile ([^]]+)\]/\1/')}")
    compadd "$@" -- $profiles
}

  compdef _prefapp_complete prefapp
