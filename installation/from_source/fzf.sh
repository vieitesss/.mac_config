#!/usr/bin/env bash

# fzf - Command-line fuzzy finder
# https://github.com/junegunn/fzf

set -euo pipefail

echo "Installing fzf from source..."

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

echo "fzf installed successfully!"
