#!/usr/bin/env bash

# Rust - Programming language
# https://www.rust-lang.org/

set -euo pipefail

echo "Installing Rust from source..."

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "Rust installed successfully!"
