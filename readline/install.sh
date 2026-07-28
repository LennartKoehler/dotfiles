#!/bin/bash
set -euo pipefail

echo "readline config - no external dependencies needed."

if [ -e "$HOME/.inputrc" ] && [ ! -L "$HOME/.inputrc" ]; then
    mkdir -p "${FRESH_MARK_DIR:-/tmp/dotfiles-fresh-install}"
    touch "${FRESH_MARK_DIR:-/tmp/dotfiles-fresh-install}/readline"
fi
