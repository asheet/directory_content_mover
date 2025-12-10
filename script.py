#!/usr/bin/env python3
"""
Python Script
Description: Move contents from subdirectories to a central 'abc' directory
Author: 
Date: 2025-11-18
"""

import os
import sys
import shutil
from pathlib import Path


# ANSI color codes for output
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    NC = '\033[0m'  # No Color


def print_colored(message: str, color: str = Colors.NC) -> None:
    """Print a message with color."""
    print(f"{color}{message}{Colors.NC}")


def usage() -> None:
    """Display usage information."""
    print("Usage: python script.py [source_directory]")
    print("  source_directory: Directory containing subdirectories to process (default: current directory)")
    sys.exit(1)


def move_subdirectory_contents(source_dir: Path, target_dir: Path) -> None:
    """Move all contents from source directory to target directory."""
    print_colored(f"Processing directory: {source_dir}", Colors.YELLOW)
    
    # Get all items in source directory (including hidden files)
    items = list(source_dir.iterdir())
    
    # Check if source directory is empty
    if not items:
        print_colored("  Directory is already empty, skipping...", Colors.YELLOW)
        return
    
    # Move all contents to target directory
    count = 0
    for item in items:
        destination = target_dir / item.name
        shutil.move(str(item), str(destination))
        print_colored(f"  Moved: {item.name}", Colors.GREEN)
        count += 1
    
    print_colored(f"  Total items moved: {count}", Colors.GREEN)


def main(source_directory: str = ".") -> None:
    """Main function to process subdirectories."""
    # Convert to absolute path
    source_dir = Path(source_directory).resolve()
    
    print_colored(f"Source directory: {source_dir}", Colors.YELLOW)
    
    # Check if source directory exists
    if not source_dir.is_dir():
        print_colored(f"Error: Directory '{source_dir}' does not exist", Colors.RED)
        sys.exit(1)
    
    # Create 'abc' directory at the root of source directory if it doesn't exist
    target_dir = source_dir / "abc"
    
    if not target_dir.exists():
        target_dir.mkdir(parents=True)
        print_colored(f"Created target directory: {target_dir}", Colors.GREEN)
    else:
        print_colored(f"Target directory already exists: {target_dir}", Colors.YELLOW)
    
    print()
    print("----------------------------------------")
    print("Starting to process subdirectories...")
    print("----------------------------------------")
    print()
    
    # Loop through each subdirectory
    processed = 0
    deleted = 0
    
    # Get all subdirectories (excluding 'abc')
    subdirs = [d for d in source_dir.iterdir() if d.is_dir() and d.name != "abc"]
    
    for subdir in subdirs:
        dirname = subdir.name
        
        print()
        print(f"Processing: {dirname}")
        print("----------------------------------------")
        
        # Move contents to target directory
        move_subdirectory_contents(subdir, target_dir)
        
        # Check if directory is now empty
        remaining_items = list(subdir.iterdir())
        if not remaining_items:
            print_colored("  Directory is empty, deleting...", Colors.YELLOW)
            subdir.rmdir()
            print_colored(f"  Deleted: {dirname}", Colors.GREEN)
            deleted += 1
        else:
            print_colored("  Warning: Directory is not empty, not deleting", Colors.RED)
        
        processed += 1
        print("----------------------------------------")
    
    print()
    print("=========================================")
    print("Summary:")
    print(f"  Subdirectories processed: {processed}")
    print(f"  Subdirectories deleted: {deleted}")
    print(f"  All contents moved to: {target_dir}")
    print("=========================================")


if __name__ == "__main__":
    # Get source directory from command line argument (default to current directory)
    source_directory = sys.argv[1] if len(sys.argv) > 1 else "."
    
    # Convert to absolute path
    source_dir = Path(source_directory).resolve()
    
    # Count folders (excluding 'abc' if it exists)
    folders = [d for d in source_dir.iterdir() if d.is_dir() and d.name != "abc"]
    folder_count = len(folders)
    
    print_colored(f"Found {folder_count} directories to process", Colors.YELLOW)
    print()
    
    # Run main function for each folder
    for i in range(1, folder_count + 1):
        print()
        print_colored(f"================== RUN {i} of {folder_count} ==================", Colors.GREEN)
        main(source_directory)
    
    print()
    print_colored("All iterations complete!", Colors.GREEN)

