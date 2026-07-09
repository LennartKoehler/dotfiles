PACKAGES = bash readline nvim tmux kitty opencode
STOW = stow --target=$(HOME) --dotfiles --ignore=install.sh
# opencode is a git submodule meant to be symlinked as a whole directory
# (folding). node_modules must live inside that single symlink, so opencode
# must NOT use --no-folding — unfolding node_modules into per-file symlinks
# breaks it. Other packages use --no-folding to merge into existing dirs.
FRESH_MARK_DIR := /tmp/dotfiles-fresh-install

.PHONY: all install deps link unlink update clean install-%

all: install

install: deps link
	@echo ""
	@echo "Setup complete. Run: source ~/.bashrc"

deps:
	@rm -rf $(FRESH_MARK_DIR)
	@mkdir -p $(FRESH_MARK_DIR)
	@for pkg in $(PACKAGES); do \
		echo "=== $$pkg ==="; \
		FRESH_MARK_DIR=$(FRESH_MARK_DIR) ./$$pkg/install.sh; \
	done

link:
	@mkdir -p $(HOME)/.config $(HOME)/.local/bin $(HOME)/.bashrc.d $(HOME)/.vim/undodir
	@for pkg in $(PACKAGES); do \
		if [ -f "$(FRESH_MARK_DIR)/$$pkg" ]; then \
			echo "Fresh install: $$pkg - clearing default configs..."; \
			./scripts/clear-defaults.sh "$$pkg"; \
		fi; \
		echo "Stowing $$pkg..."; \
		if [ "$$pkg" = "opencode" ]; then \
			if [ -f "$(FRESH_MARK_DIR)/opencode" ] && [ -e "$(HOME)/.config/opencode" ] && [ ! -L "$(HOME)/.config/opencode" ]; then \
				rm -rf $(HOME)/.config/opencode; \
			fi; \
			$(STOW) $$pkg || true; \
		else \
			$(STOW) --no-folding $$pkg || true; \
		fi; \
	done
	@./scripts/setup-bashrc.sh
	@rm -rf $(FRESH_MARK_DIR)

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
		if [ "$$pkg" = "opencode" ]; then \
			$(STOW) -R $$pkg || true; \
		else \
			$(STOW) -R --no-folding $$pkg || true; \
		fi; \
	done

clean:
	@for pkg in $(PACKAGES); do \
		stow -D --target=$(HOME) --dotfiles $$pkg || true; \
	done

install-%:
	@./$*/install.sh

