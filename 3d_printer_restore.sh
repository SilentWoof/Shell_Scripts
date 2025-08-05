#!/bin/bash

CONFIG_DIR=~/printer_data/config
BACKUP_DIR="${CONFIG_DIR}_original"
# Change the repo url to the location of the git repo
REPO_URL="https://github.com/SilentWoof/Voron_0_2_Orange.git"
LOG_FILE=~/printer_setup.log

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
