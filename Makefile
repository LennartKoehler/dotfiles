STOW_PACKAGES = nvim tmux kitty bash
STOW = stow --target=$(HOME) --dotfiles --no-folding --adopt

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
	@./scripts/setup-bashrc.sh

unlink:
	@for pkg in $(STOW_PACKAGES); do \
		echo "Unstowing $$pkg..."; \
		stow -D --target=$(HOME) --dotfiles $$pkg 2>/dev/null || true; \
	done
	@echo "Run: stow -D --target=$(HOME) --dotfiles opencode"

update:
	@echo "Pulling latest..."
	@git pull --recurse-submodules
	@for pkg in $(STOW_PACKAGES); do \
		echo "Restowing $$pkg..."; \
		stow -R --target=$(HOME) --dotfiles --no-folding $$pkg 2>/dev/null || true; \
	done

clean:
	@for pkg in $(STOW_PACKAGES); do \
		stow -D --target=$(HOME) --dotfiles $$pkg 2>/dev/null || true; \
	done
