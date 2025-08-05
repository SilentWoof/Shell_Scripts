#!/bin/bash

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
