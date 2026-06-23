#!/bin/bash
set -euo pipefail

echo "Installing tmux..."

sudo apt-get update
sudo apt-get install -y tmux xclip

echo "tmux installed."
