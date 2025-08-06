#!/bin/bash
# This script sets up the Pimoroni.com Fan SHIM cooling service on a Raspberry Pi.
# It performs system updates and installs necessary packages (git and pip),
# clones the Fan SHIM Python repository from Pimoroni's GitHub,
# installs the Fan SHIM Python library and its system service,
# and configures the fan to turn on at 65°C and off at 55°C with a 2-second delay.

sudo apt update && sudo apt upgrade -y && sudo apt autoremove && sudo autoclean
sudo apt install git python3-pip -y
mkdir downloads
cd downloads
git clone https://github.com/pimoroni/fanshim-python
cd fanshim-python
sudo ./install.sh
cd examples
sudo ./install-service.sh --on-threshold 65 --off-threshold 55 --delay 2
