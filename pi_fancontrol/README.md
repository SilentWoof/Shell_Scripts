# 🌀 Raspberry Pi Fan Controller Installer

A Bash-based installer for a Python-powered fan controller on Raspberry Pi, designed for Debian-based systems (e.g. Raspberry Pi OS). It sets up a systemd service to automatically manage your fan based on CPU temperature.

## 📦 Features

- Installs a lightweight Python script to control a GPIO-connected fan
- Automatically starts the fan controller using systemd
- Monitors CPU temperature and toggles fan based on thresholds
- Logs installation output to `/var/log/pi_fancontroller.log`
- Includes a clean uninstall option

## 🛠️ Requirements

- Raspberry Pi running a Debian-based OS (e.g. Raspberry Pi OS)
- GPIO-connected fan (default GPIO pin: 17)
    **NOTE: Do NOT connect the fan directly to the GPIO pins, a transistor circuit must be used**
- Python 3 installed
- `gpiozero` Python library (installed automatically if missing)
- Must be run as root (use `sudo`)

## 🚀 Installation
Make new file on your Raspberry Pi:
*nano pi_fancontrol.sh*
Copy and paste the contents of: 
https://github.com/SilentWoof/Scripts/tree/main/shell_scripts/pi_fancontrol/pi_fancontrol.sh
into the new file.
Make the file execuutable:
*sudo chmod +x pi_fancontrol.sh*
Run the installer:
*sudo ./pi_fancontrol.sh*

## 🗑️ Uninstall
The script contains an uninstaller. To run it use --uninstall:
*sudo pi_fancontrol.sh --uninstall*