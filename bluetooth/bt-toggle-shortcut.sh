mkdir -p ~/.local/bin

# Create Bluetooth Toggle script
cat > ~/.local/bin/bt-toggle.sh << 'EOF'
#!/bin/bash

# Check if Bluetooth is currently blocked (off)
if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
    # Turn ON
    rfkill unblock bluetooth
    
    # Wait for Bluetooth to be ready
    sleep 1
    
    # Check if we have stored connected devices
    if [ -f /tmp/bt-connected-devices ] && [ -s /tmp/bt-connected-devices ]; then
        # Try to reconnect to previously connected devices
        while read device; do
            bluetoothctl connect "$device" 2>/dev/null &
        done < /tmp/bt-connected-devices
        
        # Brief wait for connections to establish
        sleep 1
        notify-send -t 500 "Bluetooth" "Enabled and reconnected"
    else
        # No stored devices, try default devices in parallel
        (bluetoothctl connect A8:85:5D:4D:AF:6C 2>/dev/null && pkill -P $$ bluetoothctl) &
        (bluetoothctl connect 64:8F:DB:F3:C4:83 2>/dev/null && pkill -P $$ bluetoothctl) &
        
        # Wait briefly for one to connect
        sleep 1
        notify-send -t 500 "Bluetooth" "Enabled"
    fi
else
    # Turn OFF
    # Store currently connected devices before turning off
    bluetoothctl devices Connected | cut -f2 -d' ' > /tmp/bt-connected-devices
    
    rfkill block bluetooth
    notify-send -t 500 "Bluetooth" "Disabled"
fi
EOF
chmod +x ~/.local/bin/bt-toggle.sh

# Set up single keybinding for toggle
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

# Alt+B to toggle Bluetooth
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Bluetooth Toggle'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "$HOME/.local/bin/bt-toggle.sh"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Alt>b'
