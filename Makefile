PACKAGES = bash readline nvim tmux kitty opencode
STOW = stow --target=$(HOME) --dotfiles --no-folding --ignore=install.sh

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
	@for pkg in $(PACKAGES); do \
		echo "Stowing $$pkg..."; \
		$(STOW) $$pkg || true; \
	done
	@./scripts/setup-bashrc.sh

unlink:
	@for pkg in $(PACKAGES); do \
		echo "Unstowing $$pkg..."; \
		stow -D --target=$(HOME) --dotfiles $$pkg || true; \
	done

update:
	@echo "Pulling latest..."
	@git pull --recurse-submodules
	@git submodule update --remote --merge
	@for pkg in $(PACKAGES); do \
		echo "Restowing $$pkg..."; \
		stow -R --target=$(HOME) --dotfiles --no-folding --ignore=install.sh $$pkg || true; \
	done

clean:
	@for pkg in $(PACKAGES); do \
		stow -D --target=$(HOME) --dotfiles $$pkg || true; \
	done

install-%:
	@./$*/install.sh
