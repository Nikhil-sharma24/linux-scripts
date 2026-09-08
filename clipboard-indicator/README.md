Clipboard Indicator with Numeric Shortcuts
===========================================

Patch:
clipboard-indicator-numeric-shortcuts.patch

Base upstream commit:
c880c7f (v71)

## Features Added

### Numeric Quick-Selection Shortcuts
- **Ctrl+1 through Ctrl+9**: While clipboard menu is open, paste the Nth visible item
- **Ctrl+Alt+1 through Ctrl+Alt+9**: Direct paste without opening menu
- **Number labels (1-9)**: Display next to first 9 visible items in menu
- Works with search filtering (numbers update for filtered results)
- Works even when search field is focused

### Previous Fixes Included
- Paste on select + Move item to top race/selection issue (PR #619)
- Keeps indicator synchronized with selected item

## Installation

1. Apply the patch to clipboard-indicator extension directory
2. Compile the schema:
   ```bash
   make compile-settings
   ```
3. Reload the extension:
   ```bash
   gnome-extensions disable clipboard-indicator@tudmotu.com
   gnome-extensions enable clipboard-indicator@tudmotu.com
   ```
4. **On Wayland**: Logout and login for changes to take effect

## Testing

Populate clipboard with test items:
```bash
./populate_clipboard.sh
```

Test shortcuts:
- Open menu with Super+V
- Press Ctrl+2 (should paste item2)
- Close menu and press Ctrl+Alt+3 (should paste item3 directly)

Watch logs:
```bash
journalctl -f -o cat /usr/bin/gnome-shell | grep "Clipboard Indicator"
```

## How It Works

### In-Menu Shortcuts (Ctrl+1-9)
- Numbers 1-9 displayed next to first 9 visible items
- Press Ctrl+Number to select and paste that item
- Works with search - numbers update for filtered results
- Works when search field has focus

### Direct Paste (Ctrl+Alt+1-9)
- Pastes item without opening menu
- Respects "Paste on select" setting
- Respects "Move item to top after selection" setting

### Technical Details
- Virtual keyboard sends Shift+Insert (or Ctrl+Shift+Insert in terminals)
- Menu closes before paste to restore focus to target window
- 150ms delay for focus transfer before sending keystrokes
- Waits for modifier keys to be released before pasting

## Settings

Tested with:
- Paste on select: ON
- Move item to top after selection: ON

Shortcuts are configurable in extension preferences under the Shortcuts tab.

## Upstream PR

Original race-condition fix:
https://github.com/Tudmotu/gnome-shell-extension-clipboard-indicator/pull/619
