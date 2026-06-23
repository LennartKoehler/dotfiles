# Dotfiles

Personal development environment setup using [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
git clone --recurse-submodules git@github.com:lennartkoehler/dotfiles.git ~/dotfiles
cd ~/dotfiles
make install
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

## Make Targets

| Target    | Action                              |
| --------- | ----------------------------------- |
| `install` | Install stow + symlink all configs  |
| `deps`    | Check/install dependencies          |
| `link`    | Stow all packages                   |
| `unlink`  | Remove all symlinks                 |
| `update`  | Pull + restow                       |
| `clean`   | Remove all symlinks                 |

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
│   └── setup-bashrc.sh
└── Makefile
```

## Adding opencode submodule

```bash
git submodule add <opencode-repo-url> opencode
make link
```
