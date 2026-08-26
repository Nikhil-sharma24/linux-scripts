# Dual Boot Bluetooth Fix (Windows ↔ Ubuntu)

## Problem

In dual boot systems:

- Windows 11
- Ubuntu

both OSes generate different Bluetooth pairing keys for the same device.

Result:
- device works in one OS
- breaks in the other
- requires re-pairing repeatedly

---

# Core Idea

Whichever OS was paired LAST becomes the “source of truth”.

You copy that OS’s Bluetooth key → into the other OS.

---

# Your Current Setup

| Item | Value |
|---|---|
| Adapter MAC | `00:45:E2:D9:39:12` |
| Device MAC | `A8:85:5D:4D:AF:6C` |
| Device | `UBON BT-370` |

---

# IMPORTANT: Pair Once In Ubuntu First

Before syncing keys:

- pair/connect the headphones once in Ubuntu
- this creates the required Bluetooth folder + `info` file
- pair again in windows as the pairing key resets

Check devices:

```bash
bluetoothctl devices
```

Without this, the file below will not exist:

```text
/var/lib/bluetooth/<adapter-mac>/<device-mac>/info
```

---

# Extract Key From Windows (via chntpw)

## 1. Install

```bash
sudo apt install chntpw
```

---

## 2. Mount Windows Partition

Example:

```bash
sudo mount /dev/nvme0n1p3 /mnt
```

---

## 3. Open SYSTEM Registry Hive

```bash
cd /mnt/Windows/System32/config
sudo chntpw -e SYSTEM
```

---

## 4. Navigate Registry

Run these commands exactly:

```text
cd ControlSet001
cd Services
cd BTHPORT
cd Parameters
cd Keys
```

---

## 5. Enter Adapter MAC

Windows removes colons + lowercase.

Example:

```text
cd 0045e2d93912
```

---

## 6. List Devices

```text
ls
```

Example output:

```text
a8855d4daf6c
```

---

## 7. Read Device Key

```text
cat a8855d4daf6c
```

Example:

```text
:00000  8F B4 86 CC BE 0E 8D D8 12 DA 50 CD B3 16 E7 A1
```

Actual key:

```text
8fb486ccbe0e8dd812da50cdb316e7a1
```

(remove spaces + lowercase)

---

# Sync Key Into Ubuntu

## 1. Open Bluetooth Info File

```bash
sudo nano /var/lib/bluetooth/00:45:E2:D9:39:12/A8:85:5D:4D:AF:6C/info
```

---

## 2. Replace LinkKey

Find:

```ini
[LinkKey]
Key=...
```

Replace with:

```ini
Key=8fb486ccbe0e8dd812da50cdb316e7a1
```

---

## 3. Restart Bluetooth

```bash
sudo systemctl restart bluetooth
```

---

# Verify

Reconnect earbuds.

If successful:
- audio connects normally
- no re-pairing needed between OS switches

---

# Important Rules

## Safe Actions (do NOT change key)

- reboot
- connect/disconnect
- restart bluetooth
- switching OS

---

## Actions That CHANGE Key

- remove device
- forget device
- re-pair
- factory reset earbuds

If any of these happen:
- extract latest key again
- sync again

---

# Quick Recovery Workflow

If Bluetooth breaks later:

1. Pair device in whichever OS you want
2. Extract that OS key
3. Replace key in other OS
4. Restart bluetooth
5. Done

Usually takes under 2 minutes.
