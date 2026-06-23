#!/bin/bash
set -euo pipefail

echo "Installing stow..."

if command -v stow >/dev/null 2>&1; then
    echo "stow already installed"
else
    sudo apt-get update
    sudo apt-get install -y stow
fi

echo "stow installed."
