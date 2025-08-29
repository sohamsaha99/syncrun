#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/yourname/syncrun.git}"
PREFIX="${PREFIX:-$HOME/.local}"           # install root
BIN_DIR="${BIN_DIR:-$PREFIX/bin}"
ETC_DIR="${ETC_DIR:-$PREFIX/etc/syncrun}"
TMP_DIR="$(mktemp -d)"

echo "[syncrun] Installing to $PREFIX ..."
command -v git >/dev/null 2>&1 || { echo "git required"; exit 1; }

git clone --depth=1 "$REPO_URL" "$TMP_DIR"

mkdir -p "$BIN_DIR" "$ETC_DIR"
install -m 0755 "$TMP_DIR/bin/sync-run" "$BIN_DIR/sync-run"
# Optional defaults:
if [[ -f "$TMP_DIR/etc/default-config.sh" && ! -f "$HOME/.config/sync-run/config.sh" ]]; then
  mkdir -p "$HOME/.config/sync-run"
  cp "$TMP_DIR/etc/default-config.sh" "$HOME/.config/sync-run/config.sh"
  echo "[syncrun] Wrote ~/.config/sync-run/config.sh"
fi

# Add to PATH if needed
case ":$PATH:" in
  *":$BIN_DIR:"*) : ;;
  *)  # shell rc detection
      SHELL_RC="${HOME}/.bashrc"
      [[ -n "${ZSH_VERSION:-}" ]] && SHELL_RC="${HOME}/.zshrc"
      echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$SHELL_RC"
      echo "[syncrun] Added $BIN_DIR to PATH (restart shell)"
      ;;
esac

# Save version for doctor
cp "$TMP_DIR/VERSION" "$ETC_DIR/VERSION" 2>/dev/null || true

rm -rf "$TMP_DIR"
echo "[syncrun] Done. Try: sync-run --help"

