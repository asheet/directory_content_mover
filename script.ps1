# PowerShell Script (Windows Compatible)
# Description: Move contents from subdirectories to a central 'abc' directory
# Author: 
# Date: 2025-11-18

param(
    [string]$SourceDirectory = "."
)

# Stop on errors
$ErrorActionPreference = "Stop"

# Function to display usage
function Show-Usage {
    Write-Host "Usage: .\script.ps1 [-SourceDirectory <path>]"
    Write-Host "  SourceDirectory: Directory containing subdirectories to process (default: current directory)"
    exit 1
}

# Function to move subdirectory contents
function Move-SubdirectoryContents {
    param(
        [string]$SourceDir,
        [string]$TargetDir
    )
    
    Write-Host "Processing directory: $SourceDir" -ForegroundColor Yellow
    
    # Check if source directory is empty
    $items = Get-ChildItem -Path $SourceDir -Force -ErrorAction SilentlyContinue
    if (-not $items) {
        Write-Host "  Directory is already empty, skipping..." -ForegroundColor Yellow
        return
    }
    
    # Move all contents to target directory
    $count = 0
    
    foreach ($item in $items) {
        Move-Item -Path $item.FullName -Destination $TargetDir -Force
        Write-Host "  Moved: $($item.Name)" -ForegroundColor Green
        $count++
    }
    
    Write-Host "  Total items moved: $count" -ForegroundColor Green
}

# Main function
function Main {
    param(
        [string]$InputDir
    )
    
    # Get source directory (default to current directory)
    if ([string]::IsNullOrEmpty($InputDir)) {
        $InputDir = "."
    }
    
    # Convert to absolute path
    $sourceDir = (Resolve-Path $InputDir).Path
    
    Write-Host "Source directory: $sourceDir" -ForegroundColor Yellow
    
    # Check if source directory exists
    if (-not (Test-Path $sourceDir -PathType Container)) {
        Write-Host "Error: Directory '$sourceDir' does not exist" -ForegroundColor Red
        exit 1
    }
    
    # Create 'abc' directory at the root of source directory if it doesn't exist
    $targetDir = Join-Path $sourceDir "abc"
    
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir | Out-Null
        Write-Host "Created target directory: $targetDir" -ForegroundColor Green
    } else {
        Write-Host "Target directory already exists: $targetDir" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "----------------------------------------"
    Write-Host "Starting to process subdirectories..."
    Write-Host "----------------------------------------"
    Write-Host ""
    
    # Loop through each subdirectory
    $processed = 0
    $deleted = 0
    
    $subdirs = Get-ChildItem -Path $sourceDir -Directory -Force | Where-Object { $_.Name -ne "abc" }
    
    foreach ($subdir in $subdirs) {
        $dirname = $subdir.Name
        
        Write-Host ""
        Write-Host "Processing: $dirname"
        Write-Host "----------------------------------------"
        
        # Move contents to target directory
        Move-SubdirectoryContents -SourceDir $subdir.FullName -TargetDir $targetDir
        
        # Check if directory is now empty
        $remaining = Get-ChildItem -Path $subdir.FullName -Force -ErrorAction SilentlyContinue
        if (-not $remaining) {
            Write-Host "  Directory is empty, deleting..." -ForegroundColor Yellow
            Remove-Item -Path $subdir.FullName -Force
            Write-Host "  Deleted: $dirname" -ForegroundColor Green
            $deleted++
        } else {
            Write-Host "  Warning: Directory is not empty, not deleting" -ForegroundColor Red
        }
        
        $processed++
        Write-Host "----------------------------------------"
    }
    
    Write-Host ""
    Write-Host "========================================="
    Write-Host "Summary:"
    Write-Host "  Subdirectories processed: $processed"
    Write-Host "  Subdirectories deleted: $deleted"
    Write-Host "  All contents moved to: $targetDir"
    Write-Host "========================================="
}

# Get source directory (default to current directory)
if ([string]::IsNullOrEmpty($SourceDirectory)) {
    $SourceDirectory = "."
}
$sourceDir = (Resolve-Path $SourceDirectory).Path

# Count folders (excluding 'abc' if it exists)
$folders = Get-ChildItem -Path $sourceDir -Directory -Force | Where-Object { $_.Name -ne "abc" }
$folderCount = ($folders | Measure-Object).Count

Write-Host "Found $folderCount directories to process" -ForegroundColor Yellow
Write-Host ""

# Run main function for each folder
for ($i = 1; $i -le $folderCount; $i++) {
    Write-Host ""
    Write-Host "================== RUN $i of $folderCount ==================" -ForegroundColor Green
    Main -InputDir $SourceDirectory
}

Write-Host ""
Write-Host "All iterations complete!" -ForegroundColor Green

