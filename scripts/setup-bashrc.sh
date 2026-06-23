#!/bin/bash
set -euo pipefail

BASHRC="$HOME/.bashrc"
MARKER="# >>> dotfiles >>>"
CLOSER="# <<< dotfiles <<<"

SNIPPET="$MARKER
if [ -d \"\$HOME/.bashrc.d\" ]; then
    for f in \"\$HOME/.bashrc.d\"/*.sh; do
        . \"\$f\"
    done
    unset f
fi
$CLOSER"

if ! grep -qF "$MARKER" "$BASHRC" 2>/dev/null; then
    printf '\n%s\n' "$SNIPPET" >> "$BASHRC"
    echo "Added dotfiles sourcing to $BASHRC"
else
    echo "Dotfiles sourcing already in $BASHRC"
fi
