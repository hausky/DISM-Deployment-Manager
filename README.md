Readme
Windows Imaging Script

This is a batch script designed to simplify the process of capturing and applying Windows images using the Deployment Image Servicing and Management (DISM) tool. The script runs in the Windows Preinstallation Environment (WinPE) and offers several features:

Searching for a volume with an Images folder.
Capturing an image of the current Windows installation.
Formatting the current drive with a Windows UEFI scheme.
Listing and applying available .wim images.
Creating a boot record with BCDBoot.
Offering to reboot the computer after the process is complete.
Prerequisites
A Windows system running on a standard WinPE environment.
Access to the command prompt.
An Images folder on a disk with Windows images (.wim files).
Usage
To use this script, follow these steps:

Open the command prompt in the WinPE environment.

Run the batch script. You can do this by navigating to the script's location using the cd command, then typing the name of the script and pressing Enter.

Follow the prompts in the command line interface. The script will guide you through the process of capturing and applying an image, formatting the drive, and restarting the computer.

Customization
You can customize this script according to your needs. The areas of the script that you might want to modify include the image capturing commands, the UEFI disk formatting commands, and the DISM command for applying the selected WIM file.

Note
This script is provided as-is, and you bear the risk of using it. It is intended to be used by professional IT staff familiar with Windows deployment services.

Contributing
If you have suggestions for improving this script, please open an issue or submit a pull request.
