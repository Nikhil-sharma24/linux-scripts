import GLib from 'gi://GLib';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

let timeoutId = null;

function ensureBluetoothVisible() {
    try {
        // Execute bluetoothctl to power on and make discoverable
        GLib.spawn_command_line_async('bluetoothctl power on');
        GLib.spawn_command_line_async('bluetoothctl discoverable on');
    } catch (e) {
        logError(e, 'Force Bluetooth Visible');
    }
}

export default class Extension {
    enable() {
        // Run immediately on enable
        ensureBluetoothVisible();
        
        // Set up periodic check every 30 seconds
        timeoutId = GLib.timeout_add_seconds(
            GLib.PRIORITY_DEFAULT,
            30,
            () => {
                ensureBluetoothVisible();
                return GLib.SOURCE_CONTINUE;
            }
        );
    }

    disable() {
        if (timeoutId) {
            GLib.source_remove(timeoutId);
            timeoutId = null;
        }
    }
}
