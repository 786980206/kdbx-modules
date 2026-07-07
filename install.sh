#!/usr/bin/env bash
#
# install.sh — Install QTK as a KDB-X module
#
# Copies the qtk/ source directory into the module search path so it can be
# loaded via `qtk:use \`qtk` inside a q session.
#
# Target priority:
#   1. $QHOME/mod        — traditional q/kdb+ module directory
#   2. ~/.kx/mod         — KDB-X default module search path
#
# Usage:
#   ./bin/install.sh              # install to first available target
#   ./bin/install.sh --target /custom/path  # install to specific path
#   ./bin/install.sh --dry-run    # print what would be done, no changes
#   ./bin/install.sh --help       # show this message

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR" && pwd)"
SOURCE_DIR="$REPO_ROOT/mod"

print_usage() {
  sed -n 's/^# \?//p' "$0" | sed '1,/^Usage/ { /^Usage/q }'
  exit 0
}

# --- flag parsing ---
TARGET=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) shift; TARGET="$1" ;;
    --dry-run) DRY_RUN=true ;;
    --help|-h) print_usage ;;
    *) echo "Unknown option: $1"; print_usage ;;
  esac
  shift
done

# --- source validation ---
if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "ERROR: source directory not found at $SOURCE_DIR"
  echo "       Run this script from the kdbx-modules repository root."
  exit 1
fi

# --- determine target ---
if [[ -n "$TARGET" ]]; then
  INSTALL_DIR="$TARGET"
elif [[ -n "${QHOME:-}" && -d "$QHOME/mod" ]]; then
  INSTALL_DIR="$QHOME/mod"
elif [[ -d "$HOME/.kx/mod" ]]; then
  INSTALL_DIR="$HOME/.kx/mod"
elif [[ -n "${QHOME:-}" ]]; then
  echo "INFO: \$QHOME=$QHOME exists but \$QHOME/mod does not."
  echo "      Create $QHOME/mod and re-run, or pass --target."
  exit 1
else
  echo "INFO: Neither \$QHOME/mod nor ~/.kx/mod found."
  echo "      Create one of them, or pass --target <path>."
  exit 1
fi

# --- install ---
if [[ -d "$INSTALL_DIR" ]]; then
  echo "WARNING: $INSTALL_DIR already exists — overwriting."
fi

echo "Installing kdbx-modules to $INSTALL_DIR"

if $DRY_RUN; then
  echo "[dry-run] cp -r \"$SOURCE_DIR\" \"$INSTALL_DIR\""
  exit 0
fi

cp -rf $SOURCE_DIR/* "$INSTALL_DIR"

echo "Done. Load the module from q with:"
echo "  mod:use \`ws.xxx"
