mkdir -p ~/.local/bin

# Create Bluetooth ON script
cat > ~/.local/bin/bt-on.sh << 'EOF'
#!/bin/bash
rfkill unblock bluetooth

# Wait for Bluetooth to be ready
sleep 1

# Check if we have stored connected devices
if [ -f /tmp/bt-connected-devices ]; then
    # Try to reconnect to previously connected devices
    while read device; do
        bluetoothctl connect "$device" 2>/dev/null &
    done < /tmp/bt-connected-devices
    
    # Brief wait for connections to establish
    sleep 1
    notify-send -t 500 "Bluetooth" "Enabled and reconnected"
else
    notify-send -t 500 "Bluetooth" "Enabled"
fi
EOF
chmod +x ~/.local/bin/bt-on.sh

# Create Bluetooth OFF script
cat > ~/.local/bin/bt-off.sh << 'EOF'
#!/bin/bash

# Store currently connected devices before turning off
bluetoothctl devices Connected | cut -f2 -d' ' > /tmp/bt-connected-devices

rfkill block bluetooth
notify-send -t 2000 "Bluetooth" "Disabled"
EOF
chmod +x ~/.local/bin/bt-off.sh

# Set up both custom keybindings
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

# Alt+B to turn Bluetooth ON
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Bluetooth On'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "$HOME/.local/bin/bt-on.sh"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Alt>b'

# Ctrl+Alt+B to turn Bluetooth OFF
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Bluetooth Off'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "$HOME/.local/bin/bt-off.sh"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Alt>v'