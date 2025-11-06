#!/usr/bin/env bash

# k9s - Kubernetes CLI To Manage Your Clusters In Style! 
# https://github.com/derailed/k9s

set -euo pipefail

echo "Installing k9s..."

source ~/.mac_config/aliases/general.aliases.sh

arch=$(get_arch)
if [[ "${arch}" == "unknown" ]]
then
    echo "[ERROR] Unknown arquitecture"
    exit 1
fi

file="k9s_linux_${arch}.deb"

wget "https://github.com/derailed/k9s/releases/latest/download/${file}"
sudo dpkg -i "${file}"
k9s version
rm "${file}"

echo "k9s installed successfully!"
