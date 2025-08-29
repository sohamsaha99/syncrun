SHELL := /usr/bin/env bash
VERSION_FILE := VERSION
BIN := bin/sync-run

.PHONY: help
help:
	@echo "Targets: install, update, uninstall, doctor, lint, bump-patch, bump-minor, bump-major, release"

.PHONY: install
install:
	@PREFIX="$(HOME)/.local" bash ./install.sh

.PHONY: update
update:
	@set -euo pipefail; \
	install -m 0755 $(BIN) $(HOME)/.local/bin/sync-run; \
	cp -f $(VERSION_FILE) $(HOME)/.local/etc/syncrun/VERSION 2>/dev/null || true; \
	echo "[syncrun] Updated."

.PHONY: uninstall
uninstall:
	@rm -f $(HOME)/.local/bin/sync-run
	@rm -rf $(HOME)/.local/etc/syncrun
	@echo "[syncrun] Uninstalled."

.PHONY: doctor
doctor:
	@command -v sync-run >/dev/null || { echo "sync-run not on PATH"; exit 1; }
	@echo "sync-run -> $$(command -v sync-run)"
	@echo "Version: $$(cat $(HOME)/.local/etc/syncrun/VERSION 2>/dev/null || echo 'unknown')"

.PHONY: lint
lint:
	@shellcheck $(BIN) || true

bump-%:
	@ver=$$(cat $(VERSION_FILE)); \
	IFS=. read -r MAJ MIN PAT <<<$$ver; \
	case "$*" in \
	  patch) PAT=$$((PAT+1));; \
	  minor) MIN=$$((MIN+1)); PAT=0;; \
	  major) MAJ=$$((MAJ+1)); MIN=0; PAT=0;; \
	esac; \
	new="$$MAJ.$$MIN.$$PAT"; \
	echo $$new > $(VERSION_FILE); \
	echo "Version -> $$new"

.PHONY: bump-patch bump-minor bump-major
bump-patch: bump-patch
bump-minor: bump-minor
bump-major: bump-major

.PHONY: release
release:
	@git add -A
	@git commit -m "Release $$(cat $(VERSION_FILE))" || true
	@git tag "v$$(cat $(VERSION_FILE))" -f
	@git push --follow-tags

