#!/bin/bash
set -euo pipefail

echo "Installing neovim dependencies..."

PKGS=(
    neovim
    ripgrep
    nodejs
    npm
    xclip
    gcc
    g++
    make
    cmake
    unzip
    git
    python3
    python3-venv
    python3-pip
)

NEOVIM_FRESH=0
if ! command -v nvim >/dev/null 2>&1; then
    NEOVIM_FRESH=1
fi

sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y "${PKGS[@]}"

# nvim-treesitter (main branch) compiles parsers with the tree-sitter CLI
if ! command -v tree-sitter >/dev/null 2>&1; then
    sudo npm install -g tree-sitter-cli
fi

if [ "$NEOVIM_FRESH" -eq 1 ]; then
    mkdir -p "${FRESH_MARK_DIR:-/tmp/dotfiles-fresh-install}"
    touch "${FRESH_MARK_DIR:-/tmp/dotfiles-fresh-install}/nvim"
fi

echo "neovim dependencies installed."
