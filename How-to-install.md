# Installing Windows Imaging Script on WinPE

This guide explains how to install the Windows Imaging Script on a WinPE environment by overwriting the `startnet.cmd` file.

## Step 1: Prepare Your WinPE Environment

First, you need a working WinPE environment. You can create a WinPE media using the Windows Assessment and Deployment Kit (Windows ADK). Check out [this official guide](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive) from Microsoft to create a basic WinPE environment.

## Step 2: Mount the WinPE Image

1. Open the Deployment and Imaging Tools Environment as an administrator. You can find this in the Start Menu under "Windows Kits".
2. Run the command `dism /mount-wim /wimfile:"path\to\boot.wim" /index:1 /mountdir:"path\to\mount\directory"` where `path\to\boot.wim` is the path to your `boot.wim` file and `path\to\mount\directory` is the path to a folder where the image will be mounted.

## Step 3: Add the Script to the Mounted WinPE Image

1. Locate `startnet.cmd` in the `path\to\mount\directory\Windows\System32` directory.
2. Backup the existing `startnet.cmd` file by renaming it, for example, to `startnet_backup.cmd`.
3. Create a new `startnet.cmd` file in the same location.
4. Copy and paste the content from this script into the new `startnet.cmd` file.
5. Save and close `startnet.cmd`.

## Step 4: Unmount the WinPE Image

1. Return to the Deployment and Imaging Tools Environment.
2. Run the command `dism /unmount-wim /mountdir:"path\to\mount\directory" /commit` to unmount the image and save the changes.

## Step 5: Copy the Updated WinPE Image to a USB Drive

1. Format your USB drive to the FAT32 file system.
2. Copy the updated `boot.wim` file to the `sources` folder of the USB drive. If the folder doesn't exist, create it.
3. You can also copy other WinPE files (like `bootmgr` and the `boot` folder) to the root of the USB drive if necessary.

## Step 6: Use the Script

Now you're ready to use the script. Just boot your computer from the WinPE USB drive, and `startnet.cmd` will run automatically when WinPE starts.

## Step 7: Recovery

If you wish to restore the original functionality of `startnet.cmd`, simply replace the modified `boot.wim` file with the backup you created before the modifications.

**Note**: Please be careful when working with `startnet.cmd` as it is a critical boot stage file for the WinPE environment. Making a mistake could prevent WinPE from booting up correctly. It's recommended to have a backup of the original `boot.wim` file for recovery.
