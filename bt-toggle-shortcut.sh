mkdir -p ~/.local/bin
cat > ~/.local/bin/bt-toggle.sh << 'EOF'
#!/bin/bash
if rfkill list bluetooth | grep -q "Soft blocked: yes"; then
    rfkill unblock bluetooth
    notify-send "Bluetooth" "Enabled"
else
    rfkill block bluetooth
    notify-send "Bluetooth" "Disabled"
fi
EOF
chmod +x ~/.local/bin/bt-toggle.sh

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Bluetooth Toggle'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "$HOME/.local/bin/bt-toggle.sh"

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Alt>b'