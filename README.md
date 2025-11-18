# Directory Content Mover

A bash script that consolidates contents from multiple subdirectories into a single destination directory.

## Overview

This script automates the process of moving files from multiple subdirectories into a centralized directory named `abc`. After moving the contents, it verifies each subdirectory is empty and removes it automatically.

## Features

- ✅ Creates the target `abc` directory automatically if it doesn't exist
- ✅ Moves all files and folders from subdirectories (including hidden files)
- ✅ Safely skips the target directory to prevent circular moves
- ✅ Verifies directories are empty before deletion
- ✅ Color-coded output for easy monitoring
- ✅ Detailed progress tracking and summary report
- ✅ Error handling with safe exit on failures

## Requirements

- Bash shell (version 4.0+)
- Standard Unix utilities (`mv`, `ls`, `mkdir`, `rmdir`)

## Installation

1. Download or clone the script:
```bash
git clone <repository-url>
cd directory_move
```

2. Make the script executable:
```bash
chmod +x script.sh
```

## Usage

### Basic Usage

Run the script in a directory containing subdirectories:

```bash
./script.sh
```

This will:
1. Process all subdirectories in the current directory
2. Move their contents to `./abc/`
3. Delete empty subdirectories

### Specify a Directory

You can specify a target directory to process:

```bash
./script.sh /path/to/directory
```

## Example

### Before Running the Script

```
my_project/
├── 1/
│   └── a.txt
├── 2/
│   └── b.txt
├── 3/
│   └── c.txt
└── 4/
    └── d.txt
```

### Run the Script

```bash
./script.sh
```

### After Running the Script

```
my_project/
└── abc/
    ├── a.txt
    ├── b.txt
    ├── c.txt
    └── d.txt
```

All subdirectories (1, 2, 3, 4) have been removed, and their contents consolidated into `abc/`.

## Output

The script provides color-coded output:

- **Green**: Successful operations (files moved, directories deleted)
- **Yellow**: Informational messages (processing status, warnings)
- **Red**: Errors or warnings (non-empty directories, failures)

### Sample Output

```
Source directory: /Users/username/my_project
Created target directory: /Users/username/my_project/abc

----------------------------------------
Starting to process subdirectories...
----------------------------------------

Processing: 1
----------------------------------------
Processing directory: /Users/username/my_project/1
  Moved: a.txt
  Total items moved: 1
  Directory is empty, deleting...
  Deleted: 1
----------------------------------------

=========================================
Summary:
  Subdirectories processed: 4
  Subdirectories deleted: 4
  All contents moved to: /Users/username/my_project/abc
=========================================
```

## Safety Features

1. **Non-destructive verification**: Directories are only deleted if confirmed empty
2. **Target directory protection**: The `abc` directory is automatically skipped to prevent circular operations
3. **Error handling**: Script exits on errors to prevent data loss
4. **Hidden file support**: Moves both regular and hidden files (dotfiles)

## Limitations

- Only processes direct subdirectories (not recursive)
- Target directory name is fixed as `abc`
- Requires write permissions in the source directory

## Troubleshooting

### Permission Denied

Ensure you have write permissions:
```bash
chmod +x script.sh
```

### Directory Not Empty Warning

If a subdirectory is not deleted, it means files remain. Check for:
- Hidden files or directories
- Permission issues
- Files being used by other processes

### Script Not Found

Make sure you're in the correct directory or use the full path:
```bash
/full/path/to/script.sh
```

## License

This script is provided as-is for free use and modification.

## Author

Created: November 18, 2025

## Version History

- **v1.0** (2025-11-18): Initial release
  - Basic directory content moving functionality
  - Automatic cleanup of empty directories
  - Color-coded output and progress tracking

