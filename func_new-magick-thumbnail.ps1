function new-magick-thumbnails {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]  [String]$path, ## path to directory of images
        [Parameter(Mandatory = $true)]  [String]$resize ## percent to resize the images
    )
    ## check if provided path is good
    Write-Verbose "Checking path..."
    if (!(Test-Path $path)) { Write-Host "An error occurred. Path provided doesn't exist. Try again." -ForegroundColor Red }
    ## check if path is actually a Directory
    if ($(Get-ItemProperty $path).Attributes -ne "Directory") { Write-Host "An error occurred. Path provided isn't a dirctory. Try again." -ForegroundColor Red }
    
    ## check if winget is installed, needed to install ImageMagick in the next check
    Write-Verbose "Checking if winget is installed..."
    try {
        winget | out-null
    }
    catch {
        Write-Host "An error occurred. You don't have winget installed.  Go fix that and come back." -ForegroundColor Red
    }
    ## check if ImageMagick is installed, if not installed, it installs ImageMagick.Q16-HDRI
    Write-Verbose "Checking if ImageMagick is installed..."
    if (!(winget list --name ImageMagick) -like "ImageMagick Q16-HDRI ImageMagick.Q16-HDRI 7*") {
        Write-Host "ImageMagick not installed." -ForegroundColor Red
        Write-Host "Installing ImageMagick..." -ForegroundColor Green
        winget install ImageMagick.Q16-HDRI
    }
    ## check if magick is installed and working
    Write-Verbose "Checking if magick is installed and working..."
    try {
        magick --version | out-null
    }
    catch {
        Write-Host "An error occurred. ImageMagick might not be installed or failed to install. `nTry restarting powershell, if that doesn't fix it, trobleshoot ImageMagick install." -ForegroundColor Red
    }
    ## check if the directory path ends with a \ and if it doesn't, add it.
    if ($path[-1] -notmatch "\`\") { $path = $path + "`\" }
    ## get list of jpg files from directory
    Write-Verbose "Getting list of jpg files from provided path..."
    $imgs = Get-ChildItem -Path $path | Where-Object { ($_.name -Like "*.jpg") -or ($_.name -Like "*.jpeg") -or ($_.name -Like "*.png") }
    ## loop through each file and create thumbnail file
    Write-Verbose "Looping through each file and creating thumbnail file"
    foreach (
        $img in $imgs
    ) { 
        ## set thumbnail file name
        Write-Verbose "Creating thumbnail file name..."
        $fileSmlName = $path + $img.BaseName + "_thumb" + $img.Extension
        Write-Verbose "$fileSmlName"
        magick $img.FullName -resize $resize $fileSmlName 
    }
}