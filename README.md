# Windows Imaging Script

This repository contains a batch script designed to streamline the process of capturing and applying Windows images using the Deployment Image Servicing and Management (DISM) tool. It is intended to run in the Windows Preinstallation Environment (WinPE). 

## Features

- **Automated Drive Search**: Locates the volume containing an `Images` folder.
- **Image Capture**: Offers to captures an image of the current Windows installation and saves it in the "Images" folder (from whatever drive).
- **Drive Formatting**: Offers the option to format the current drive for Windows UEFI installation.
- **Image Application**: Lists and applies available `.wim` images from the "Images" folder.
- **Boot Record Creation**: Creates a boot record with BCDBoot.
- **Reboot Option**: Offers to reboot the computer after the process is complete.

## Prerequisites

- A Windows system running in a standard WinPE environment.
- Access to the command prompt.
- An `Images` folder on a disk with Windows images (`.wim` files).

## Usage

1. Open the command prompt in the WinPE environment.
2. Navigate to the directory containing the batch script using `cd`.
3. Run the script by typing its name and pressing Enter.
4. Follow the prompts in the command line interface. The script will guide you through each step of the process.

## Customization

You can modify this script according to your requirements. The areas of the script you might want to customize include:

- Image capturing commands.
- UEFI disk formatting commands.
- DISM command for applying the selected WIM file.

## Note

Please understand that this script is provided as-is, and you bear the risk of using it. It is intended to be utilized by professional IT staff familiar with Windows deployment services.

## Contributing

Suggestions for improvements are welcome. Please open an issue or submit a pull request to contribute.

## License

This project is licensed under the terms of the MIT license.
