 =========================================================
 WINDOWS KEY EXTRACTION — chntpw
 =========================================================

 If you need a fresh Windows Bluetooth key:

 
 1. Open the Windows SYSTEM registry:

    cd /run/media/nikhil/Windows-SSD/Windows/System32/config
    sudo chntpw -e SYSTEM

 3. Navigate inside chntpw:

    cd ControlSet001
    cd Services
    cd BTHPORT
    cd Parameters
    cd Keys
    cd 0045e2d93912
    ls


    <!-- "cat <device-mac> for details" -->


 4. Enter your Bluetooth adapter MAC.

    Ubuntu:
      00:45:E2:D9:39:12

    chntpw:
      0045e2d93912

    Example:

      cd 0045e2d93912

 5. List devices:

      ls

 6. Find your headphone MAC using Ubuntu:

      bluetoothctl devices

    Example:

      Device 64:8F:DB:F3:C4:83 OPPO Enco Buds3 Pro

    Convert it for chntpw:

      648fdbf3c483

 7. Read the Windows pairing key:

      cat 648fdbf3c483

    Example:

      :00000  6A 43 5A E4 48 8F 56 7F 3B 3D 8F E2 DA 16 05 D6

    Remove spaces + lowercase:

      6a435ae4488f567f3b3d8fe2da1605d6

    IMPORTANT:
      No `hex` command is required.
      `cat` already displays the key as hexadecimal bytes.

 8. Exit without modifying Windows:

      q

    If asked to save changes:

      n

 =========================================================