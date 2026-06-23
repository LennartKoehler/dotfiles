PACKAGES = bash nvim tmux kitty opencode
STOW = stow --target=$(HOME) --dotfiles --no-folding

.PHONY: all install deps link unlink update clean install-%

all: install

install: deps link
	@echo ""
	@echo "Setup complete. Run: source ~/.bashrc"

deps:
	@for pkg in $(PACKAGES); do \
		echo "=== $$pkg ==="; \
		./$$pkg/install.sh; \
	done

link:
	@mkdir -p $(HOME)/.config $(HOME)/.local/bin $(HOME)/.bashrc.d $(HOME)/.vim/undodir
	@for pkg in nvim tmux kitty bash; do \
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
	@for pkg in nvim tmux kitty bash opencode; do \
		echo "Unstowing $$pkg..."; \
		stow -D --target=$(HOME) --dotfiles $$pkg 2>/dev/null || true; \
	done

update:
	@echo "Pulling latest..."
	@git pull --recurse-submodules
	@git submodule update --remote --merge
	@for pkg in nvim tmux kitty bash; do \
		echo "Restowing $$pkg..."; \
		stow -R --target=$(HOME) --dotfiles --no-folding $$pkg 2>/dev/null || true; \
	done
	@stow -R --target=$(HOME) --dotfiles opencode 2>/dev/null || true

clean:
	@for pkg in nvim tmux kitty bash opencode; do \
		stow -D --target=$(HOME) --dotfiles $$pkg 2>/dev/null || true; \
	done

install-%:
	@./$*/install.sh
