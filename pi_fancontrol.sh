#!/bin/bash

# ==============================================================================
# Raspberry Pi Fan Controller Installer
# Version: 1.3
# Author: SilentWoof     https://github.com/SilentWoof
# Based on: https://github.com/Howchoo/pi-fan-controller by Howchoo
# Description: Installs a Python-based fan controller with systemd integration
# ==============================================================================

LOG_FILE="/var/log/pi_fancontroller.log"

function exit_with_log {
  echo ""
  echo "📄 Installation log saved to $LOG_FILE"
  exit "$1"
}

# Optional uninstall mode
if [[ "$1" == "--uninstall" ]]; then
  if [ "$(id -u)" -ne 0 ]; then
    echo ""
    echo "❌ Uninstall must be run as root. Try: sudo $0 --uninstall"
    exit 1
  fi

  echo "🧹 Uninstalling pi_fancontroller..."

  echo "🔻 Stopping systemd service..."
  systemctl stop pi_fancontroller.service

  echo "🚫 Disabling systemd service..."
  systemctl disable pi_fancontroller.service

  echo "🗑️ Removing systemd service file..."
  rm -f /etc/systemd/system/pi_fancontroller.service

  echo "🗑️ Removing controller script..."
  rm -f /usr/local/bin/pi_fancontroller.py

  echo ""
  read -r -p "Do you also want to delete the log file at $LOG_FILE? [y/N]: " remove_log
  case "$remove_log" in
    [yY][eE][sS]|[yY])
      if [ -f "$LOG_FILE" ]; then
        echo "🧹 Removing log file..."
        rm -f "$LOG_FILE"
        echo "✅ Log file removed."
      else
        echo "⚠️ Log file not found. Nothing to remove."
      fi
      ;;
    *)
      echo "📄 Log file retained at $LOG_FILE."
      ;;
  esac

  echo ""
  echo "✅ pi_fancontroller successfully uninstalled."
  exit 0
fi

echo ""
echo "📘 This script will:"
echo "  • Install a Python-based fan controller for Raspberry Pi"
echo "  • Check for and install gpiozero if missing"
echo "  • Create the controller script at /usr/local/bin/pi_fancontroller.py"
echo "  • Set up a systemd service to run it automatically on boot"
echo "  • Log installation output to /var/log/pi_fancontroller.log"
echo ""
echo "🔧 Requirements:"
echo "  • Must be run as root (use sudo)"
echo "  • Python 3 must be installed"
echo "  • gpiozero (will be installed if missing)"
echo ""
echo "🗑️  To uninstall run: ./pi_fancontrol.sh --uninstall"
echo ""
echo ""
read -r -p "Do you want to proceed? [y/N]: " confirm
case "$confirm" in
  [yY][eE][sS]|[yY]) echo e "\n✅ Proceeding..." ;;
  *) echo ""; echo "❌ User aborted."; exit 1 ;;
esac

if [ "$(id -u)" -ne 0 ]; then
  echo ""
  echo "❌ Must be run as root. Try: sudo $0"
  exit 1
fi

if [ ! -w /var/log ]; then
  echo ""
  echo "❌ Cannot write to /var/log. Check permissions."
  exit 1
fi

exec > >(tee -a "$LOG_FILE") 2>&1

if ! command -v python3 > /dev/null 2>&1; then
  echo ""
  echo "❌ Python 3 not found. Please install it."
  exit_with_log 1
fi

echo "=> Checking for gpiozero..."
if ! python3 -c "import gpiozero" 2>/dev/null; then
  echo "gpiozero not found. Installing..."
  if ! apt-get update; then
    echo ""
    echo "❌ Failed to update package list."
    exit_with_log 1
  fi
  if ! apt-get install -y python3-gpiozero; then
    echo ""
    echo "❌ Failed to install gpiozero."
    exit_with_log 1
  fi
else
  echo ""
  echo "gpiozero is already installed."
fi

echo ""
echo "=> Creating pi_fancontroller.py..."
cat > /usr/local/bin/pi_fancontroller.py << 'EOF'
#!/usr/bin/env python3

import time
from gpiozero import OutputDevice

ON_TEMP = 50
OFF_TEMP = 45

fan = OutputDevice(17)

def get_temp():
    with open("/sys/class/thermal/thermal_zone0/temp", "r") as f:
        return int(f.read()) / 1000

try:
    fan_on = False
    while True:
        temp = get_temp()
        if temp >= ON_TEMP and not fan_on:
            fan.on()
            fan_on = True
        elif temp <= OFF_TEMP and fan_on:
            fan.off()
            fan_on = False
        time.sleep(5)
except KeyboardInterrupt:
    fan.off()
EOF

if [ ! -f /usr/local/bin/pi_fancontroller.py ]; then
  echo ""
  echo "❌ Failed to create pi_fancontroller.py."
  exit_with_log 1
fi

chmod +x /usr/local/bin/pi_fancontroller.py
echo ""
echo "✅ pi_fancontroller.py created and made executable."

echo ""
echo "=> Creating systemd service file..."
cat > /etc/systemd/system/pi_fancontroller.service << EOF
[Unit]
Description=Raspberry Pi Fan Controller
After=network.target

[Service]
ExecStart=/usr/bin/python3 /usr/local/bin/pi_fancontroller.py
WorkingDirectory=/usr/local/bin
Restart=always
User=root
Type=simple
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

if [ ! -f /etc/systemd/system/pi_fancontroller.service ]; then
  echo ""
  echo "❌ Failed to create systemd service file."
  exit_with_log 1
fi

echo "=> Reloading systemd daemon..."
if ! systemctl daemon-reload; then
  echo ""
  echo "❌ Failed to reload systemd."
  exit_with_log 1
fi

echo "=> Enabling pi_fancontroller service..."
if ! systemctl enable pi_fancontroller.service; then
  echo ""
  echo "❌ Failed to enable pi_fancontroller.service."
  exit_with_log 1
fi

echo ""
echo "=> Starting pi_fancontroller service..."
if ! systemctl start pi_fancontroller.service; then
  echo ""
  echo "❌ Failed to start pi_fancontroller.service."
  echo ""
  echo "💡 Try checking logs with: journalctl -u pi_fancontroller.service"
  exit_with_log 1
fi

if systemctl is-active --quiet pi_fancontroller.service; then
  echo ""
  echo "✅ pi_fancontroller installed and running via systemd."
  echo "🔍 To check status: sudo systemctl status pi_fancontroller.service"
  echo "⚙️ Default fan control settings: ON_TEMP = 50°C, OFF_TEMP = 45°C"
  echo "   To change temperature thresholds, edit: /usr/local/bin/pi_fancontroller.py"
  echo "   Look for ON_TEMP and OFF_TEMP near the top of the file."
  echo ""
  echo "🗑️  To uninstall run: ./pi_fancontrol.sh --uninstall"
else
  echo ""
  echo "⚠️ Service failed to start. Check logs with: journalctl -u pi_fancontroller.service"
  exit_with_log 1
fi

exit_with_log 0