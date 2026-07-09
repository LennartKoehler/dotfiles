#!/bin/bash
set -euo pipefail

echo "Installing tmux..."

TMUX_FRESH=0
if ! command -v tmux >/dev/null 2>&1; then
    TMUX_FRESH=1
fi

sudo apt-get update
sudo apt-get install -y tmux xclip

if [ "$TMUX_FRESH" -eq 1 ]; then
    mkdir -p "${FRESH_MARK_DIR:-/tmp/dotfiles-fresh-install}"
    touch "${FRESH_MARK_DIR:-/tmp/dotfiles-fresh-install}/tmux"
fi

echo "tmux installed."
