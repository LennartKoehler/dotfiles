#!/bin/bash
set -euo pipefail

echo "Installing stow..."

if command -v stow >/dev/null 2>&1; then
    echo "stow already installed"
else
    sudo apt-get update
    sudo apt-get install -y stow
    mkdir -p "${FRESH_MARK_DIR:-/tmp/dotfiles-fresh-install}"
    touch "${FRESH_MARK_DIR:-/tmp/dotfiles-fresh-install}/bash"
fi

echo "stow installed."
