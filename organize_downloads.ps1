# Get the current user's Downloads folder
$downloadsPath = "$env:USERPROFILE\Downloads"
$othersPath = "$downloadsPath\Others"

# Define categories and their extensions
$categories = @{
    "Documents" = @("pdf", "xls", "pptx", "docx", "txt")
    "Videos"    = @("mp4", "m4a", "vlc")
    "Images"    = @("png", "jpeg", "jpg")
    "Software"  = @("exe", "iso", "msi", "ovpn")
    "Compressed" = @("zip" ,"rar")
}

# Loop through categories and move files
foreach ($category in $categories.Keys) {
    $destPath = "$downloadsPath\$category"
    
    # Create the folder if it doesn't exist
    if (!(Test-Path $destPath)) {
        New-Item -ItemType Directory -Path $destPath | Out-Null
    }
    
    foreach ($ext in $categories[$category]) {
        Get-ChildItem -Path "$downloadsPath\*.$ext" -File | ForEach-Object {
            Move-Item -Path $_.FullName -Destination $destPath -ErrorAction SilentlyContinue
        }
    }
}

# Create "Others" folder if it doesn't exist
if (!(Test-Path $othersPath)) {
    New-Item -ItemType Directory -Path $othersPath | Out-Null
}

# Get all extra directories in Downloads except the defined categories
$allFolders = Get-ChildItem -Path $downloadsPath -Directory | Where-Object { $_.Name -notin $categories.Keys -and $_.Name -ne "Others" }

# Move extra folders to "Others"
foreach ($folder in $allFolders) {
    Move-Item -Path $folder.FullName -Destination $othersPath -ErrorAction SilentlyContinue
}

Write-Output "Files and folders sorted successfully!"