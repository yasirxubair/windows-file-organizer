# Get the current user's Downloads folder
$downloadsPath = "$env:USERPROFILE\Downloads"

# Define categories and their extensions
$categories = @{
    "Documents" = @("pdf", "xls", "pptx", "docx")
    "Videos"    = @("mp4", "m4a", "vlc")
    "Images"    = @("png", "jpeg", "jpg")
    "Software"  = @("exe", "iso")
}

# Loop through categories and move files
foreach ($category in $categories.Keys) {
    $destPath = "$downloadsPath\$category"
    
    # Create the folder if it doesn't exist
    if (!(Test-Path $destPath)) {
        New-Item -ItemType Directory -Path $destPath | Out-Null
    }
    
    foreach ($ext in $categories[$category]) {
        Move-Item -Path "$downloadsPath\*.$ext" -Destination $destPath -ErrorAction SilentlyContinue
    }
}
