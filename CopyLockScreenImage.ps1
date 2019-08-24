<#
.SYNOPSIS
Copy images used by Windows 10 lockscreen (Windows Spotlight) to a specified folder
.DESCRIPTION
When you see the beautiful background images in the Windows 10 login screen,
have you ever wanted to make them as your wallpaper?
And then you realize that there is no desktop settings to use those as your wallpaper?
And then you wonder whether it is possible to somehow get those images
and put them in a folder and set your background to display them as slideshow?

This script can help you:
1. copy the images from their obscure location to a folder that you specify
2. only copy images (the source folder has non-image files)
3. add ".jpg" extension to the image names (originally they don't have file name extension)
#>
param(
    [string] $targetFolder = $(throw "Please specify the target folder")
)

function isJpeg {
    param (
        [System.IO.FileSystemInfo] $file
    )

    [byte[]] $jpegHeader = 255, 216, 255, 224
    [byte[]] $fileHeader = Get-Content -Path $file.FullName -TotalCount 4 -Encoding Byte

    if ($fileHeader.Length -ne $jpegHeader.Length) {
        return $false
    }

    for ($idx = 0; $idx -lt $fileHeader.Length; $idx++) {
        if ($fileHeader[$idx] -ne $jpegHeader[$idx]) {
            return $false
        }
    }

    return $true
}

$files = Get-ChildItem -Path ($env:LOCALAPPDATA +
    "\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets") |
Where-Object { isJpeg $_ }

$files | ForEach-Object -Process {
    if (!(Test-Path "$targetFolder\$_.jpg")) {
        Copy-Item $_.FullName "$targetFolder\$_.jpg"
        Get-Item "$targetFolder\$_.jpg"
    }
}
