#!/bin/bash
set -euo pipefail

echo "Installing opencode..."

if command -v opencode >/dev/null 2>&1; then
    echo "opencode already installed"
else
    curl -fsSL https://opencode.ai/install | bash
fi

CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)/.config/opencode"

if [ -f "$CONFIG_DIR/package.json" ]; then
    echo "Installing opencode npm dependencies..."
    cd "$CONFIG_DIR"
    npm install
fi

echo "opencode setup complete."
