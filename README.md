# new-magick-thumbnails

This folder contains a small PowerShell function `new-magick-thumbnails` that creates JPEG thumbnail images from all `.jpg` files in a directory using ImageMagick's `magick` CLI.

## What it does

- Checks the provided directory exists.
- Verifies `winget` is available (used to install ImageMagick if missing).
- Installs ImageMagick `ImageMagick.Q16-HDRI` via `winget` if it's not detected.
- Uses `magick` to resize each `.jpg` in the directory and writes a thumbnail next to each file with the suffix `_thumb.jpg`.

## Prerequisites

- Windows with PowerShell (script was written for PowerShell 5.1 but will work in later versions).
- `winget` (Windows Package Manager) available if you want the script to auto-install ImageMagick.
- ImageMagick (the script will attempt to install it via `winget` if missing).

Note: Installing packages with `winget` may require an elevated (Administrator) PowerShell session.

## Installing / Loading the function

The script file is `func_new-magick-thumbnail.ps1`. To use the function in your current PowerShell session, dot-source the file:

```powershell
# From the folder containing the script
. .\\func_new-magick-thumbnail.ps1

# Now the function is available
Get-Command new-magick-thumbnails
```

Alternatively, you can copy the function into your PowerShell profile or convert it into a small module for reuse.

## Usage

The function accepts two mandatory parameters:

- `-path` : Path to the directory containing source `.jpg` images.
- `-resize` : Resize parameter passed to ImageMagick's `magick -resize` (examples below).

Example (resize by percentage):

```powershell
new-magick-thumbnails -path "C:\\Users\\You\\Pictures\\to-thumb" -resize "50%"
```

Examples (other `-resize` values ImageMagick supports):

```powershell
# Resize to a width of 200px, auto height
new-magick-thumbnails -path "C:\\path\\to\\images" -resize "200x"

# Resize and force exact dimensions (may change aspect ratio)
new-magick-thumbnails -path "C:\\path\\to\\images" -resize "200x200!"
```

Output files:
- For each `photo.jpg` the script will write `photo_thumb.jpg` into the same directory.

## Notes and behaviour

- The script only processes `*.jpg` files (case depends on your filesystem). It collects files using `Get-ChildItem -File *.jpg`.
- If the provided path does not end with a backslash, the script will append one.
- The script checks for `winget` and tries to install ImageMagick when it's not present. If `winget` is missing you'll see an error message and must install `winget` first.

## Troubleshooting

- If thumbnails are not created:
	- Confirm `magick --version` runs successfully in your session.
	- Ensure you ran PowerShell as Administrator if `winget` needs elevation to install ImageMagick.
	- Confirm your path contains `.jpg` files (and not `.jpeg` — this script only collects `*.jpg`).

- If you want to process `.jpeg` files as well, edit the script's `Get-ChildItem` call or run separate commands.

## Security / Safety

- The script will install software via `winget` if needed. Review that behavior and run in an environment where you can install packages.

## Example workflow

```powershell
# Open elevated PowerShell (if you expect to install ImageMagick)
cd C:\\path\\to\\new-magick-thumbnails
. .\\func_new-magick-thumbnail.ps1
new-magick-thumbnails -path "C:\\Users\\You\\Pictures\\set1" -resize "40%"
```

## License

This repository does not include an explicit license for the script. If you want it licensed (e.g., MIT), add a `LICENSE` file and update this README accordingly.
