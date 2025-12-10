#!/bin/bash

# Bash Script
# Description: Move contents from subdirectories to a central 'abc' directory
# Author: 
# Date: 2025-11-18

# Exit on error
set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    echo "Usage: $0 [source_directory]"
    echo "  source_directory: Directory containing subdirectories to process (default: current directory)"
    exit 1
}

# Function to move subdirectory contents
move_subdirectory_contents() {
    local source_dir="$1"
    local target_dir="$2"
    
    echo -e "${YELLOW}Processing directory: ${source_dir}${NC}"
    
    # Check if source directory is empty
    if [ -z "$(ls -A "$source_dir")" ]; then
        echo -e "${YELLOW}  Directory is already empty, skipping...${NC}"
        return
    fi
    
    # Move all contents to target directory
    local count=0
    shopt -s nullglob  # Handle case when no files match
    shopt -s dotglob   # Include hidden files
    
    for item in "$source_dir"/*; do
        # Only process if item exists and is not . or ..
        if [ -e "$item" ]; then
            local basename_item="$(basename "$item")"
            if [ "$basename_item" != "." ] && [ "$basename_item" != ".." ]; then
                mv "$item" "$target_dir/"
                echo -e "${GREEN}  Moved: $basename_item${NC}"
                ((count++))
            fi
        fi
    done
    
    shopt -u dotglob   # Disable dotglob
    shopt -u nullglob  # Disable nullglob
    
    echo -e "${GREEN}  Total items moved: ${count}${NC}"
}

# Main function
main() {
    # Get source directory (default to current directory)
    local source_dir="${1:-.}"
    
    # Convert to absolute path
    source_dir="$(cd "$source_dir" && pwd)"
    
    echo -e "${YELLOW}Source directory: ${source_dir}${NC}"
    
    # Check if source directory exists
    if [ ! -d "$source_dir" ]; then
        echo -e "${RED}Error: Directory '${source_dir}' does not exist${NC}"
        exit 1
    fi
    
    # Create 'abc' directory at the root of source directory if it doesn't exist
    local target_dir="${source_dir}/abc"
    
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        echo -e "${GREEN}Created target directory: ${target_dir}${NC}"
    else
        echo -e "${YELLOW}Target directory already exists: ${target_dir}${NC}"
    fi
    
    echo ""
    echo "----------------------------------------"
    echo "Starting to process subdirectories..."
    echo "----------------------------------------"
    echo ""
    
    # Loop through each subdirectory
    local processed=0
    local deleted=0
    
    for subdir in "$source_dir"/*/; do
        # Remove trailing slash
        subdir="${subdir%/}"
        
        # Skip if not a directory
        if [ ! -d "$subdir" ]; then
            continue
        fi
        
        # Get just the directory name
        local dirname="$(basename "$subdir")"
        
        # Skip the 'abc' target directory itself
        if [ "$dirname" = "abc" ]; then
            echo -e "${YELLOW}Skipping target directory: ${dirname}${NC}"
            continue
        fi
        
        echo ""
        echo "Processing: ${dirname}"
        echo "----------------------------------------"
        
        # Move contents to target directory
        move_subdirectory_contents "$subdir" "$target_dir"
        
        # Check if directory is now empty
        if [ -z "$(ls -A "$subdir")" ]; then
            echo -e "${YELLOW}  Directory is empty, deleting...${NC}"
            rmdir "$subdir"
            echo -e "${GREEN}  Deleted: ${dirname}${NC}"
            ((deleted++))
        else
            echo -e "${RED}  Warning: Directory is not empty, not deleting${NC}"
        fi
        
        ((processed++))
        echo "----------------------------------------"
    done
    
    echo ""
    echo "========================================="
    echo "Summary:"
    echo "  Subdirectories processed: ${processed}"
    echo "  Subdirectories deleted: ${deleted}"
    echo "  All contents moved to: ${target_dir}"
    echo "========================================="
}

# Get source directory (default to current directory)
source_dir="${1:-.}"
source_dir="$(cd "$source_dir" && pwd)"

# Count folders (excluding 'abc' if it exists)
folder_count=$(find "$source_dir" -maxdepth 1 -mindepth 1 -type d ! -name "abc" | wc -l)
# Trim whitespace from wc output
folder_count=$(echo "$folder_count" | tr -d ' ')

echo -e "${YELLOW}Found $folder_count directories to process${NC}"
echo ""

# Run main function for each folder
for ((i=1; i<=folder_count; i++)); do
    echo ""
    echo -e "${GREEN}================== RUN $i of $folder_count ==================${NC}"
    main "$@"
done

echo ""
echo -e "${GREEN}All iterations complete!${NC}"
