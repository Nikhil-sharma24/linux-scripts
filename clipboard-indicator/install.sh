#!/usr/bin/env bash
set -euo pipefail

EXT_ID="clipboard-indicator@tudmotu.com"
REPO="https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator.git"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_FILE="$SCRIPT_DIR/clipboard-indicator-pr-619.patch"
EXT_DIR="$HOME/.local/share/gnome-shell/extensions/$EXT_ID"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "==> Checking requirements..."

command -v git >/dev/null || {
    echo "Error: git is not installed."
    exit 1
}

command -v gnome-extensions >/dev/null || {
    echo "Error: gnome-extensions command is not available."
    exit 1
}

if [[ ! -f "$PATCH_FILE" ]]; then
    echo "Error: patch not found:"
    echo "  $PATCH_FILE"
    exit 1
fi

echo "==> Cloning Clipboard Indicator..."
git clone "$REPO" "$TMP_DIR/clipboard-indicator"

cd "$TMP_DIR/clipboard-indicator"

echo "==> Applying local PR #619 patch..."
git apply --3way "$PATCH_FILE"

echo "==> Installing extension..."
mkdir -p "$(dirname "$EXT_DIR")"

# Disable existing extension before replacing it.
gnome-extensions disable "$EXT_ID" 2>/dev/null || true

rm -rf "$EXT_DIR"
cp -a "$TMP_DIR/clipboard-indicator" "$EXT_DIR"

echo "==> Enabling extension..."
gnome-extensions enable "$EXT_ID"

echo
echo "=========================================="
echo " Clipboard Indicator installed successfully"
echo " PR #619 fix applied"
echo "=========================================="
echo
echo "Recommended settings:"
echo "  Paste on select:                 ON"
echo "  Move item to top after selection: ON"
echo
echo "If GNOME does not load the updated extension,"
echo "log out and log back in."
