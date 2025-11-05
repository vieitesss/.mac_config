#!/usr/bin/env zsh

prefapp() {
    # Check aws is installed
    if ! command -v aws >/dev/null 2>&1; then
        echo "[error] aws cli not found. Please install aws cli v2 from https://aws.amazon.com/cli/"
        return 1
    fi

    local profile="${1:-prefapp-admin}"
    echo -n "[info] Logging in to AWS profile: $profile ..."
    aws sso login --profile "$profile" >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo -e "\r[info] Login cancelled or failed"
        return 1
    fi
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
    profiles=($(grep '^\[profile ' ~/.aws/config | sed -E 's/^\[profile ([^]]+)\]/\1/'))
    compadd "$@" -- $profiles
}

compdef _prefapp_complete prefapp
