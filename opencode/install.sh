#!/bin/bash
set -euo pipefail

echo "Installing opencode..."

if command -v opencode >/dev/null 2>&1; then
    echo "opencode already installed"
else

    CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)/.config/opencode"

    if [ -f "$CONFIG_DIR/install.sh" ]; then
        echo "Installing opencode..."
        bash "$CONFIG_DIR/install.sh"
        echo "Opencode setup complete"
    fi
fi

