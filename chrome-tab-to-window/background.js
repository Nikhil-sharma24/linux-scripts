// Track which tabs came from which windows
const tabOrigins = new Map(); // tabId -> originalWindowId

chrome.commands.onCommand.addListener((command) => {
  if (command === "move-tab") {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      if (tabs[0]) {
        const tab = tabs[0];
        const originalWindowId = tab.windowId;
        
        // Store the original window before moving
        tabOrigins.set(tab.id, originalWindowId);
        
        chrome.windows.create({ tabId: tab.id });
      }
    });
  } else if (command === "restore-tab") {
    chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
      if (tabs[0]) {
        const tab = tabs[0];
        const currentWindowId = tab.windowId;
        const originalWindowId = tabOrigins.get(tab.id);
        
        if (originalWindowId) {
          // Check if original window still exists
          chrome.windows.get(originalWindowId, (originalWindow) => {
            if (chrome.runtime.lastError) {
              // Original window is gone, do nothing (don't close current window)
              tabOrigins.delete(tab.id);
            } else {
              // Move tab back to original window
              chrome.tabs.move(tab.id, { windowId: originalWindowId, index: -1 }, () => {
                // Activate the restored tab
                chrome.tabs.update(tab.id, { active: true }, () => {
                  // Only close the old window if the move was successful
                  chrome.tabs.query({ windowId: currentWindowId }, (remainingTabs) => {
                    if (remainingTabs.length === 0) {
                      chrome.windows.remove(currentWindowId);
                    }
                  });
                });
              });
              // Clean up tracking
              tabOrigins.delete(tab.id);
            }
          });
        } else {
          // No original window tracked, find any non-popup window to merge into
          chrome.windows.getAll({ windowTypes: ['normal'] }, (windows) => {
            if (windows.length > 1) {
              // Find a different window to merge into
              const targetWindow = windows.find(w => w.id !== currentWindowId);
              if (targetWindow) {
                chrome.tabs.move(tab.id, { windowId: targetWindow.id, index: -1 }, () => {
                  chrome.tabs.update(tab.id, { active: true }, () => {
                    // Only close if there are no remaining tabs
                    chrome.tabs.query({ windowId: currentWindowId }, (remainingTabs) => {
                      if (remainingTabs.length === 0) {
                        chrome.windows.remove(currentWindowId);
                      }
                    });
                  });
                });
              }
            }
            // If only 1 window exists, do nothing
          });
        }
      }
    });
  }
});

// Clean up tracking when tabs are closed
chrome.tabs.onRemoved.addListener((tabId) => {
  tabOrigins.delete(tabId);
});
