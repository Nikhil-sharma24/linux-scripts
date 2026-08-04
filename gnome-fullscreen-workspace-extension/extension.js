import GLib from 'gi://GLib';

let signals = [];
let createdSignal = null;

function moveToNewWorkspace(win) {
    if (win._moved)
        return;

    win._moved = true;
    
    const manager = global.workspace_manager;
    const currentWs = win.get_workspace();
    
    if (!currentWs)
        return;
    
    const currentIndex = currentWs.index();
    const lastIndex = manager.n_workspaces - 1;
    
    // Check if there are other windows on the current workspace
    const windowsOnWorkspace = currentWs.list_windows();
    const otherWindows = windowsOnWorkspace.filter(w => {
        // Skip the current window
        if (w === win) return false;
        
        // Only count normal application windows (not desktop, dock, etc.)
        const windowType = w.get_window_type();
        return windowType === 0; // META_WINDOW_NORMAL
    });
    
    // If already on last workspace OR it's the only normal window on this workspace, don't move
    if (currentIndex === lastIndex || otherWindows.length === 0) {
        win._originalWorkspaceIndex = undefined;
        return;
    }
    
    // Save the original workspace index before moving
    win._originalWorkspaceIndex = currentIndex;

    // Wait for GNOME to finish the fullscreen transition
    GLib.timeout_add(GLib.PRIORITY_DEFAULT, 150, () => {
        try {
            manager.append_new_workspace(
                false,
                global.get_current_time()
            );

            const newWorkspace =
                manager.get_workspace_by_index(
                    manager.n_workspaces - 1
                );

            win.change_workspace(newWorkspace);

            // After dynamic workspaces adds another empty workspace,
            // ensure we switch back to the workspace with our fullscreen window
            GLib.timeout_add(GLib.PRIORITY_DEFAULT, 200, () => {
                try {
                    // Get the workspace with our window (should be second to last now)
                    const windowWorkspace = win.get_workspace();
                    if (windowWorkspace) {
                        windowWorkspace.activate_with_focus(
                            win,
                            global.get_current_time()
                        );
                    }
                } catch (e) {
                    logError(e);
                }
                return GLib.SOURCE_REMOVE;
            });
        } catch (e) {
            logError(e);
        }

        return GLib.SOURCE_REMOVE;
    });
}

function moveBackToOriginalWorkspace(win) {
    if (win._originalWorkspaceIndex === undefined)
        return;

    GLib.timeout_add(GLib.PRIORITY_DEFAULT, 150, () => {
        try {
            const manager = global.workspace_manager;
            const originalIndex = win._originalWorkspaceIndex;
            
            // Validate the index is still valid
            if (originalIndex >= 0 && originalIndex < manager.n_workspaces) {
                const originalWs = manager.get_workspace_by_index(originalIndex);
                
                if (originalWs) {
                    // Move window back to original workspace
                    win.change_workspace(originalWs);
                    
                    // Activate the original workspace with the window
                    originalWs.activate_with_focus(
                        win,
                        global.get_current_time()
                    );
                }
            }
            
            // Clean up
            win._originalWorkspaceIndex = undefined;
        } catch (e) {
            logError(e);
        }

        return GLib.SOURCE_REMOVE;
    });
}

function handleWindow(win) {
    const signal = win.connect(
        'notify::fullscreen',
        () => {
            if (win.is_fullscreen()) {
                moveToNewWorkspace(win);
            } else {
                win._moved = false;
                moveBackToOriginalWorkspace(win);
            }
        }
    );

    signals.push([win, signal]);
    
    // Clean up properties when window is closed
    const unmanagedSignal = win.connect('unmanaged', () => {
        win._moved = undefined;
        win._originalWorkspaceIndex = undefined;
    });
    
    signals.push([win, unmanagedSignal]);
}

export default class Extension {
    enable() {
        global.get_window_actors().forEach(actor => {
            handleWindow(actor.meta_window);
        });

        createdSignal = global.display.connect(
            'window-created',
            (_, win) => {
                handleWindow(win);
            }
        );
    }

    disable() {
        if (createdSignal)
            global.display.disconnect(createdSignal);

        signals.forEach(([win, signal]) => {
            try {
                win.disconnect(signal);
            } catch {}
        });

        signals = [];
    }
}