# Dotfiles

Personal development environment setup using [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
git clone --recurse-submodules git@github.com:lennartkoehler/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup install
source ~/.bashrc
```

## What Gets Installed

| Package  | Symlinks to                        |
| -------- | ---------------------------------- |
| nvim     | `~/.config/nvim/`                  |
| tmux     | `~/.tmux.conf`, `~/.local/bin/tmux_*` |
| kitty    | `~/.config/kitty/kitty.conf`       |
| bash     | `~/.bashrc.d/dotfiles.sh`          |
| opencode | `~/.config/opencode/` (submodule)  |

## Prerequisites

Installs `stow` automatically. Other deps to install manually:
- `neovim`, `tmux`, `kitty`, `ripgrep`, `nodejs`, `npm`, `xclip`

## Setup Commands

| Command             | Action                              |
| ------------------- | ----------------------------------- |
| `./setup install`   | Install deps + symlink all configs  |
| `./setup deps`      | Check/install dependencies          |
| `./setup link`      | Stow all packages                   |
| `./setup unlink`    | Remove all symlinks                 |
| `./setup update`    | Pull + restow                       |
| `./setup clean`     | Remove all symlinks                 |
| `./setup install <pkg>` | Run one package's install.sh   |

## Structure

```
dotfiles/
├── nvim/                  # stow package
│   └── .config/nvim/
├── tmux/                  # stow package
│   ├── .tmux.conf
│   └── .local/bin/tmux_*
├── kitty/                 # stow package
│   └── .config/kitty/
├── bash/                  # stow package
│   └── .bashrc.d/
├── opencode/              # git submodule
├── scripts/
│   ├── clear-defaults.sh
│   └── setup-bashrc.sh
└── setup
```

## opencode

The opencode config is a git submodule pointing to [my-opencode-config](https://github.com/LennartKoehler/my-opencode-config).
It gets symlinked as a whole directory (`~/.config/opencode` -> `dotfiles/opencode/.config/opencode`).

Skills are managed separately via `skills-lock.json` inside the submodule.

If `~/.config/opencode` already exists as a real directory, `./setup link` will remove it before symlinking.
