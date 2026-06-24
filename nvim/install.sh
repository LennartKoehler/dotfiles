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
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install -y "${PKGS[@]}"

echo "neovim dependencies installed."
