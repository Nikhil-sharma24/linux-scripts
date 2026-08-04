#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_FILE="${1:-$SCRIPT_DIR/grub_bak.cfg}"
GRUB_DIR="${2:-/boot/grub}"
TARGET_FILE="$GRUB_DIR/grub.cfg"

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

if [[ ! -f "$BACKUP_FILE" ]]; then
  echo "Backup file not found: $BACKUP_FILE"
  exit 1
fi

if [[ ! -d "$GRUB_DIR" ]]; then
  echo "GRUB directory not found: $GRUB_DIR"
  exit 1
fi

TIMESTAMP="$(date +%Y%m%d%H%M%S)"
BACKUP_NAME="$(basename "$BACKUP_FILE")"

if [[ -f "$TARGET_FILE" ]]; then
  cp -v "$TARGET_FILE" "$GRUB_DIR/grub.cfg.bak.$TIMESTAMP"
  echo "Previous GRUB config saved as $GRUB_DIR/grub.cfg.bak.$TIMESTAMP"
else
  echo "No previous GRUB config was present."
fi

install -m 0644 "$BACKUP_FILE" "$TARGET_FILE"

echo "Restored GRUB config from $BACKUP_FILE to $TARGET_FILE."
