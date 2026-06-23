#!/bin/bash
set -euo pipefail

echo "Installing kitty..."

if command -v kitty >/dev/null 2>&1; then
    echo "kitty already installed"
else
    sudo apt-get update
    sudo apt-get install -y kitty
fi

echo "Installing JetBrainsMono Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

if [ ! -f "$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
    TMP=$(mktemp -d)
    curl -fsSL -o "$TMP/jetbrains.zip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -o "$TMP/jetbrains.zip" -d "$FONT_DIR" >/dev/null
    rm -rf "$TMP"
    fc-cache -f >/dev/null 2>&1 || true
    echo "Font installed."
else
    echo "Font already installed."
fi

echo "kitty setup complete."
