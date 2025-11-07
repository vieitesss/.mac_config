#!/usr/bin/env bash

# helmfile - Package manager for Kubernetes
# https://github.com/helmfile/helmfile

set -euo pipefail

echo "Installing helmfile..."

source ~/.mac_config/aliases/general.aliases.sh

arch=$(get_arch)
if [[ "${arch}" == "unknown" ]]
then
    echo "[ERROR] Unknown arquitecture"
    exit 1
fi

version="1.1.9"
file="helmfile_${version}_linux_${arch}"
share_dir="$HOME/.local/share/helmfile"

wget "https://github.com/helmfile/helmfile/releases/download/v${version}/${file}.tar.gz"

mkdir -p "${share_dir}"
rm -rf "${share_dir}/**"
mv "${file}.tar.gz" "${share_dir}"

tar xzvf "${share_dir}/${file}.tar.gz" -C "${share_dir}"
ln -s "${share_dir}/helmfile" "$HOME/.local/bin/helmfile" 

rm "${share_dir}/${file}.tar.gz"

echo "helmfile installed successfully!"
