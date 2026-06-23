STOW_PACKAGES = nvim tmux kitty bash
STOW = stow --target=$(HOME) --dotfiles --no-folding

.PHONY: all install deps link unlink update clean

all: deps link

install: deps link
	@echo "Setup complete. Run: source ~/.bashrc"

deps:
	@if ! command -v stow >/dev/null 2>&1; then \
		echo "Installing stow..."; \
		sudo apt-get update && sudo apt-get install -y stow; \
	fi
	@command -v nvim >/dev/null 2>&1 || echo "WARNING: neovim not installed"
	@command -v tmux >/dev/null 2>&1 || echo "WARNING: tmux not installed"
	@command -v kitty >/dev/null 2>&1 || echo "WARNING: kitty not installed"
	@command -v rg >/dev/null 2>&1 || echo "WARNING: ripgrep not installed"
	@command -v node >/dev/null 2>&1 || echo "WARNING: nodejs not installed"

link:
	@mkdir -p $(HOME)/.config $(HOME)/.local/bin $(HOME)/.bashrc.d
	@for pkg in $(STOW_PACKAGES); do \
		echo "Stowing $$pkg..."; \
		$(STOW) $$pkg 2>/dev/null || echo "  (skipped or already linked)"; \
	done
	@if [ -d opencode/.config/opencode ]; then \
		echo "Stowing opencode..."; \
		if [ -d $(HOME)/.config/opencode ] && [ ! -L $(HOME)/.config/opencode ]; then \
			echo "  WARNING: ~/.config/opencode exists and is not a symlink. Backing up..."; \
			mv $(HOME)/.config/opencode $(HOME)/.config/opencode.bak.$$(date +%s); \
		fi; \
		stow --target=$(HOME) --dotfiles opencode 2>/dev/null || echo "  (skipped or already linked)"; \
	fi
	@./scripts/setup-bashrc.sh

unlink:
	@for pkg in $(STOW_PACKAGES) opencode; do \
		echo "Unstowing $$pkg..."; \
		stow -D --target=$(HOME) --dotfiles $$pkg 2>/dev/null || true; \
	done

update:
	@echo "Pulling latest..."
	@git pull --recurse-submodules
	@git submodule update --remote --merge
	@for pkg in $(STOW_PACKAGES); do \
		echo "Restowing $$pkg..."; \
		stow -R --target=$(HOME) --dotfiles --no-folding $$pkg 2>/dev/null || true; \
	done
	@stow -R --target=$(HOME) --dotfiles opencode 2>/dev/null || true

clean:
	@for pkg in $(STOW_PACKAGES) opencode; do \
		stow -D --target=$(HOME) --dotfiles $$pkg 2>/dev/null || true; \
	done
