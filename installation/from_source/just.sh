#!/usr/bin/env bash

# just - Command runner
# https://github.com/casey/just

set -euo pipefail

echo "Installing just from source..."

curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/.local/bin

echo "just installed successfully!"
