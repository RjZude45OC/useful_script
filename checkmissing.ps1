# PowerShell script to compare files between two folders and show missing files

param(
    [Parameter(Mandatory=$true)]
    [string]$Folder1,
    
    [Parameter(Mandatory=$true)]
    [string]$Folder2
)

# Function to check if folders exist
function Test-FolderExists {
    param([string]$Path)
    if (-not (Test-Path -Path $Path -PathType Container)) {
        Write-Error "Folder does not exist: $Path"
        return $false
    }
    return $true
}

# Validate input folders
if (-not (Test-FolderExists $Folder1) -or -not (Test-FolderExists $Folder2)) {
    exit 1
}

Write-Host "Comparing folders:" -ForegroundColor Cyan
Write-Host "Folder 1: $($Folder1)" -ForegroundColor Yellow
Write-Host "Folder 2: $($Folder2)" -ForegroundColor Yellow
Write-Host ""

# Get file names from both folders (files only, not subdirectories)
$Files1 = Get-ChildItem -Path $Folder1 -File | Select-Object -ExpandProperty Name
$Files2 = Get-ChildItem -Path $Folder2 -File | Select-Object -ExpandProperty Name

# Find files missing in Folder2 (present in Folder1 but not in Folder2)
$MissingInFolder2 = $Files1 | Where-Object { $_ -notin $Files2 }

# Find files missing in Folder1 (present in Folder2 but not in Folder1)
$MissingInFolder1 = $Files2 | Where-Object { $_ -notin $Files1 }

# Display results
Write-Host "=== COMPARISON RESULTS ===" -ForegroundColor Green
Write-Host ""

if ($MissingInFolder2.Count -gt 0) {
    Write-Host "Files missing in $($Folder2):" -ForegroundColor Red
    foreach ($file in $MissingInFolder2) {
        Write-Host "  - $file" -ForegroundColor White
    }
    Write-Host ""
} else {
    Write-Host "No files missing in $($Folder2)" -ForegroundColor Green
    Write-Host ""
}

if ($MissingInFolder1.Count -gt 0) {
    Write-Host "Files missing in $($Folder1):" -ForegroundColor Red
    foreach ($file in $MissingInFolder1) {
        Write-Host "  - $file" -ForegroundColor White
    }
    Write-Host ""
} else {
    Write-Host "No files missing in $($Folder1)" -ForegroundColor Green
    Write-Host ""
}

# Summary
$TotalFiles1 = $Files1.Count
$TotalFiles2 = $Files2.Count
$CommonFiles = ($Files1 | Where-Object { $_ -in $Files2 }).Count

Write-Host "=== SUMMARY ===" -ForegroundColor Cyan
Write-Host "Total files in $($Folder1): $TotalFiles1"
Write-Host "Total files in $($Folder2): $TotalFiles2"
Write-Host "Common files: $CommonFiles"
Write-Host "Files missing in $($Folder1): $($MissingInFolder1.Count)"
Write-Host "Files missing in $($Folder2): $($MissingInFolder2.Count)"

# Example usage:
# .\Compare-Folders.ps1 -Folder1 'C:\Path\To\Folder1' -Folder2 'C:\Path\To\Folder2'
# or
# .\Compare-Folders.ps1 -Folder1 "C:\Users\YourName\Documents\Folder1" -Folder2 "C:\Users\YourName\Documents\Folder2"