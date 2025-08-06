#!/bin/bash
# ------------------------------------------------------------------------------
# Script Name: 3d_printer_restore.sh
#
# Description:
# This script automates the restoration of Klipper 3D printer configuration files
# by backing up the existing configuration directory and replacing it with a fresh
# clone from a specified Git repository. It performs the following steps:
#
#   1. Checks for the existence of the current configuration directory.
#   2. If found, renames it to preserve the original as a backup.
#   3. Creates a new, clean configuration directory.
#   4. Clones the contents of the specified Git repository into the new directory.
#   5. Logs all actions and timestamps to a log file for traceability.
#
# Variables:
#   CONFIG_DIR   - Path to the current printer configuration directory.
#   BACKUP_DIR   - Path to store the backup of the original configuration.
#   REPO_URL     - URL of the Git repository containing the desired configuration.
#   LOG_FILE     - Path to the log file where script activity is recorded.
#
# Usage:
#   Run this script on a system with Git installed and access to the target repo.
#   Ensure that the CONFIG_DIR path and REPO_URL are correctly set before execution.
#
# Author: SilentWoof (GitHub)
# ------------------------------------------------------------------------------

CONFIG_DIR=~/printer_data/config
BACKUP_DIR="${CONFIG_DIR}_original"
# Change the repo url to the location of the git repo
REPO_URL="https://github.com/SilentWoof/Voron_0_2_Orange.git"
LOG_FILE=~/klipper_3d_printer_restore.log

echo "---- Starting script at $(date) ----" | tee -a "$LOG_FILE"

# Check if config directory exists
if [ -d "$CONFIG_DIR" ]; then
    echo "Directory $CONFIG_DIR found. Backing it up to $BACKUP_DIR..." | tee -a "$LOG_FILE"
    mv "$CONFIG_DIR" "$BACKUP_DIR" || { echo "Failed to rename directory." | tee -a "$LOG_FILE"; exit 1; }
else
    echo "No existing config directory found. Proceeding with setup..." | tee -a "$LOG_FILE"
fi

# Create clean config directory
mkdir -p "$CONFIG_DIR" || { echo "Failed to create $CONFIG_DIR." | tee -a "$LOG_FILE"; exit 1; }

# Change to the config directory
cd "$CONFIG_DIR" || { echo "Failed to change directory to $CONFIG_DIR." | tee -a "$LOG_FILE"; exit 1; }

# Clone repository contents directly
echo "Cloning repository into $CONFIG_DIR..." | tee -a "$LOG_FILE"
git clone "$REPO_URL" . || { echo "Git clone failed." | tee -a "$LOG_FILE"; exit 1; }

echo "Repository cloned successfully." | tee -a "$LOG_FILE"
echo "---- Script finished at $(date) ----" | tee -a "$LOG_FILE"
