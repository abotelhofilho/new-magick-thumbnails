# new-magick-thumbnails


This is a PowerShell function `new-magick-thumbnails` that finds image files and creates thumbnails using ImageMagick's `magick` CLI.

## What it does

- Checks the provided path exists and verifies it is a directory.
- Verifies `winget` is available (used to install ImageMagick if missing).
- Installs ImageMagick `ImageMagick.Q16-HDRI` via `winget` if it's not detected.
- Enumerates image files (jpg / jpeg / png) and uses `magick -resize` to create thumbnails next to each file, preserving the original file extension and adding the `_thumb` suffix (e.g. `photo.jpg` -> `photo_thumb.jpg`).

## Prerequisites

- Windows with PowerShell (script was written for PowerShell 5.1 but will work in later versions).
- `winget` (Windows Package Manager) available if you want the script to auto-install ImageMagick.
- ImageMagick (the script will attempt to install it via `winget` if missing).

Note: Installing packages with `winget` may require an elevated (Administrator) PowerShell session.

## Installing / Loading the function

The script file is `func_new-magick-thumbnail.ps1`. To use the function in your current PowerShell session, dot-source the file:

```powershell
# From the folder containing the script
. .\func_new-magick-thumbnail.ps1
```

## Usage

The function accepts two mandatory parameters:

- `-path` : Path to the directory containing source images.
- `-resize` : Resize parameter passed to ImageMagick's `magick -resize` (examples below).

Example (resize by percentage):

```powershell
new-magick-thumbnails -path "C:\Users\You\Pictures\to-thumb" -resize "50%"
```

Examples (other `-resize` values ImageMagick supports):

```powershell
# Resize to a width of 200px, auto height
new-magick-thumbnails -path "C:\path\to\images" -resize "200x"

# Resize and force exact dimensions (may change aspect ratio)
new-magick-thumbnails -path "C:\path\to\images" -resize "200x200!"
```

Output files:
- For each `photo.jpg` the script will write `photo_thumb.jpg` into the same directory.

## Notes and behaviour

- The script looks for files with the extensions `.jpg`, `.jpeg`, and `.png` and will create thumbnails that keep the same extension (for example, `image.png` -> `image_thumb.png`).
- It validates the `-path` parameter exists and is a directory; if the path does not end with a backslash the function appends one.
- The script checks for `winget` and will attempt to install ImageMagick when it's not present. If `winget` is missing you'll see an error message and must install `winget` first.

## Troubleshooting

- If thumbnails are not created:
	- Confirm `magick --version` runs successfully in your session.
	- Ensure you ran PowerShell as Administrator if `winget` needs elevation to install ImageMagick.

## Security / Safety

- The script will install software via `winget` if needed. Review that behavior and run in an environment where you can install packages.

## Example workflow

```powershell
# Open elevated PowerShell (if you expect to install ImageMagick)
cd C:\path\to\new-magick-thumbnails
. .\func_new-magick-thumbnail.ps1
new-magick-thumbnails -path "C:\Users\You\Pictures\set1" -resize "40%"
```

