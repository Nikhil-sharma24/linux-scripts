#!/bin/bash

# =========================================================
# Dual Boot Bluetooth Sync Helper
# Select device -> paste Windows key -> sync to Ubuntu
# =========================================================

set -e

ADAPTER=$(bluetoothctl list | awk '{print $2}')

if [ -z "$ADAPTER" ]; then
    echo "❌ No Bluetooth adapter found"
    exit 1
fi

echo ""
echo "🔵 Bluetooth Adapter: $ADAPTER"
echo ""

# ---- Collect devices ----
mapfile -t DEVICES < <(bluetoothctl devices)

if [ ${#DEVICES[@]} -eq 0 ]; then
    echo "❌ No paired devices found"
    exit 1
fi

echo "📱 Select Bluetooth device:"
echo ""

for i in "${!DEVICES[@]}"; do
    LINE="${DEVICES[$i]}"
    MAC=$(echo "$LINE" | awk '{print $2}')
    NAME=$(echo "$LINE" | cut -d' ' -f3-)

    echo "[$((i+1))] $NAME ($MAC)"
done

echo ""
read -p "👉 Enter number: " CHOICE

INDEX=$((CHOICE-1))

if [ ! "${DEVICES[$INDEX]}" ]; then
    echo "❌ Invalid selection"
    exit 1
fi

DEVICE_MAC=$(echo "${DEVICES[$INDEX]}" | awk '{print $2}')
DEVICE_NAME=$(echo "${DEVICES[$INDEX]}" | cut -d' ' -f3-)

INFO_FILE="/var/lib/bluetooth/$ADAPTER/$DEVICE_MAC/info"

echo ""
echo "🎧 Selected: $DEVICE_NAME"
echo "🔑 Device MAC: $DEVICE_MAC"

if ! sudo test -f "$INFO_FILE"; then
    echo ""
    echo "❌ Ubuntu pairing info not found."
    echo "💡 Pair/connect device in Ubuntu once first."
    exit 1
fi

echo ""
read -p "🔑 Paste Windows Bluetooth key: " WINKEY

WINKEY=$(echo "$WINKEY" | tr -d ' ' | tr '[:upper:]' '[:lower:]')

if [[ ! "$WINKEY" =~ ^[0-9a-f]{32}$ ]]; then
    echo "❌ Invalid key format"
    exit 1
fi

echo ""
echo "💾 Creating backup..."
sudo cp "$INFO_FILE" "$INFO_FILE.bak"

echo "📝 Updating key..."

sudo sed -i \
"/^\[LinkKey\]/,/^\[/{s/^Key=.*/Key=$WINKEY/}" \
"$INFO_FILE"

echo "🔄 Restarting Bluetooth..."
sudo systemctl restart bluetooth

echo ""
echo "✅ Bluetooth key synced successfully!"
echo "🎧 Reconnect your headphones if needed."
echo ""
echo "🛟 Backup saved at:"
echo "$INFO_FILE.bak"
