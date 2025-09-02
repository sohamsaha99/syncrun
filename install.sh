#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/sohamsaha99/syncrun.git}"
PREFIX="${PREFIX:-$HOME/.local}"           # install root
BIN_DIR="${BIN_DIR:-$PREFIX/bin}"
TMP_DIR="$(mktemp -d)"

echo "[syncrun] Installing to $PREFIX ..."
command -v git >/dev/null 2>&1 || { echo "git required"; exit 1; }

git clone --depth=1 "$REPO_URL" "$TMP_DIR"

mkdir -p "$BIN_DIR"
install -m 0755 "$TMP_DIR/bin/syncrun" "$BIN_DIR/syncrun"
# Optional defaults:
if [[ ! -f "$HOME/.config/syncrun/config.sh" ]]; then
  mkdir -p "$HOME/.config/syncrun"
  cp "$TMP_DIR/examples/default-config.sh" "$HOME/.config/syncrun/config.sh"
  echo "[syncrun] Wrote default config at ~/.config/syncrun/config.sh"
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

rm -rf "$TMP_DIR"
echo "[syncrun] Done. Try: syncrun --help"

