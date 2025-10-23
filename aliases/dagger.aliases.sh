#!/usr/bin/env bash

install_dagger () {
    local version=${1:-latest}

    echo "Install Dagger CLI version: $version"
    curl -fsSL https://dl.dagger.io/dagger/install.sh | DAGGER_VERSION="$version" BIN_DIR=/usr/local/bin sudo -E sh

    dagger version
}

dagger_work () {
    install_dagger "0.18.8"
}

dagger_latest () {
    install_dagger
}
