#!/usr/bin/env bash

# helmfile - Package manager for Kubernetes
# https://github.com/helmfile/helmfile

set -euo pipefail

source ~/.mac_config/aliases/general.aliases.sh

arch=$(get_arch)
if [[ "${arch}" == "unknown" ]]
then
    echo "[ERROR] Unknown arquitecture"
    exit 1
fi

version="1.1.9"
file="helmfile_${version}_linux_${arch}.tar.gz"
share_dir="$HOME/.local/share/helmfile"

wget "https://github.com/helmfile/helmfile/releases/download/v${version}/${file}"

mkdir -p "${share_dir}"
rm -rf "${share_dir}/**"
mv "${file}" "${share_dir}"

tar xzvf "${share_dir}/${file}" -C "${share_dir}"

binary="$HOME/.local/bin/helmfile" 
if [[ -f "$binary" ]]
then
    rm "$binary" 
fi
ln -s "${share_dir}/helmfile" "$binary"

rm "${share_dir}/${file}"

echo "[INFO] helmfile installed successfully!"
