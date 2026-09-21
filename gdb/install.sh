#!/bin/bash
set -euo pipefail

if ! command -v gdb >/dev/null 2>&1; then
    echo "Installing gdb..."
    sudo apt-get update
    sudo apt-get install -y gdb
fi

if [ -e "$HOME/.gdbinit" ] && [ ! -L "$HOME/.gdbinit" ]; then
    echo "Existing ~/.gdbinit found - will be backed up on fresh install."
    mkdir -p "${FRESH_MARK_DIR:-/tmp/dotfiles-fresh-install}"
    touch "${FRESH_MARK_DIR:-/tmp/dotfiles-fresh-install}/gdb"
fi
