#!/usr/bin/env bash

# Helm - Package manager for Kubernetes
# https://helm.sh/docs/

set -euo pipefail

echo "Installing Helm..."

sudo apt-get install curl gpg apt-transport-https --yes
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

echo "Helm installed successfully!"

echo "Installing Helm diff plugin..."

helm plugin install https://github.com/databus23/helm-diff

echo "Helm diff plugin installed successfully!"
