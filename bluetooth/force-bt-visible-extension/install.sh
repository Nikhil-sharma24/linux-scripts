#!/bin/bash

set -e

EXT_DIR="$HOME/.local/share/gnome-shell/extensions/force-bt-visible@nikhil"

mkdir -p "$EXT_DIR"

cp extension.js "$EXT_DIR/"
cp metadata.json "$EXT_DIR/"

gnome-extensions disable force-bt-visible@nikhil 2>/dev/null || true
gnome-extensions enable force-bt-visible@nikhil

echo "Force Bluetooth Visible extension installed and enabled."
echo "Bluetooth will now stay powered on and discoverable."
