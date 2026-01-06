# Robocopy GUI

A simple graphical interface for Windows Robocopy command, making file synchronization and backup tasks easier to configure and execute.

## Overview

This tool provides a user-friendly GUI wrapper around the powerful Robocopy command-line utility. It allows you to configure common Robocopy options through an intuitive interface without remembering complex command syntax.

## Features

- Path Selection: Visual source and destination folder selection with browse buttons
- Mirror Mode (/MIR): Option to mirror directories (delete files in destination that don't exist in source)
- Subdirectories (/E): Copy subdirectories including empty ones
- Copy Security (/SEC): Copy files with security attributes and ACLs
- Retry Configuration (/R): Configurable number of retries on failed copies
- Wait Time (/W): Adjustable wait time between retries (in seconds)
- Multi-Threading (/MT): Configure number of threads for parallel file copying (default: 8)
- Dry Run Mode (/L): Preview operations without actually copying files (for testing purpose)
- Command Preview: Real-time preview of the generated Robocopy command
- Output Log: Live display of Robocopy execution output
- Copy Command: Copy the generated command to clipboard for manual use
- Modern Dark UI: Clean and modern interface with good visibility

## Requirements

- Windows operating system (Windows 7 or later)
- Robocopy (included by default in modern Windows 10/11 versions)

## Installation

1. Download the latest release from the Releases page
2. Extract the ZIP file to your preferred location
3. Run the executable file

No additional installation required.

## Usage

1. **Select Source and Destination**: Click the browse buttons to choose your source and destination folders
2. **Configure Options**: Select your desired Robocopy options (mirror, copy subdirectories, etc.)
3. **Preview Command**: View the generated Robocopy command before execution
4. **Execute**: Click the Run button to start the copy operation
5. **Monitor Progress**: Watch the real-time output in the log window

## Common Use Cases

- Backup important folders to external drives
- Synchronize folders between network locations
- Mirror directory structures
- Scheduled file replication tasks


## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Support

For issues or questions, please open an issue on the GitHub repository.
