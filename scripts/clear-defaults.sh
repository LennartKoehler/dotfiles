#!/bin/bash
set -euo pipefail

PKG="$1"
DOTFILES_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG_DIR="$DOTFILES_ROOT/$PKG"

while IFS= read -r -d '' file; do
    rel="${file#"$PKG_DIR"/}"
    target="$HOME/$rel"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "  Removing default: $target"
        rm -rf "$target"
    fi
done < <(find "$PKG_DIR" -type f -not -name 'install.sh' -print0)
