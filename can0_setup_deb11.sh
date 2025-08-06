#!/bin/bash
# ------------------------------------------------------------------------------
# Script Name: setup_can0.sh
#
# Description:
# This script configures the CAN0 (Controller Area Network) interface on a Linux
# system by creating a static network configuration file. It ensures safe setup
# by backing up any existing configuration and writing a new one with predefined
# parameters. The script must be run with root privileges.
#
# Functionality:
#   1. Verifies that the script is executed with elevated (root) privileges.
#   2. Checks for an existing CAN0 configuration file.
#   3. If found, backs up the original file to preserve previous settings.
#   4. Writes a new CAN0 configuration with:
#        - Static interface setup
#        - Bitrate of 500000
#        - TX queue length of 1024
#   5. Provides clear status messages for each step.
#
# Variables:
#   CAN_FILE     - Path to the CAN0 network configuration file.
#   BACKUP_FILE  - Path to store the backup of the original CAN0 configuration.
#
# Usage:
#   Run this script using sudo:
#     sudo ./setup_can0.sh
#
# Notes:
#   - Designed for Debian-based systems using /etc/network/interfaces.d/
#   - Requires root access to modify network configuration files.
#
# Author: SilentWoof [GitHub: https://github.com/SilentWoof]
# ------------------------------------------------------------------------------


# setup_can0.sh - Configure CAN0 interface on Linux

CAN_FILE="/etc/network/interfaces.d/can0"
BACKUP_FILE="/etc/network/interfaces.d/can0.original"

# ✅ Check for root privileges
if [ "$EUID" -ne 0 ]; then
    echo "❌ This script must be run with elevated privileges."
    echo "🔁 Please rerun it using: sudo ./setup_can0.sh"
    exit 1
fi

# 📦 Backup existing can0 file if it exists
if [ -f "$CAN_FILE" ]; then
    echo "🔄 Existing can0 file found. Attempting backup..."
    if ! mv "$CAN_FILE" "$BACKUP_FILE"; then
        echo "❗ Failed to back up $CAN_FILE. Check permissions."
        exit 2
    fi
    echo "✅ Backup successful."
fi

# ✍️ Create new can0 configuration
echo "🛠 Creating new CAN0 configuration..."
if ! cat <<EOF > "$CAN_FILE"
auto can0
iface can0 can static
    bitrate 500000
    up ifconfig \$IFACE txqueuelen 1024
EOF
then
    echo "❗ Error writing to $CAN_FILE. Check permissions or disk space."
    exit 3
fi

echo "✅ CAN0 interface configuration completed successfully."
