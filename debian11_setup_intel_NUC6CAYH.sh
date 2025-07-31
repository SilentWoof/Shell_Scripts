#! /bin/bash
# Initial setup script for Debian 11 on Intel NUC6CAYH systems
#
# This script automates essential post-installation tasks for a clean Debian 11 setup,
# specifically tailored for the Intel NUC6CAYH hardware platform.
#
# Functions performed by this script include:
# - Backup of the existing APT sources list
# - Enabling of the non-free repositories required for additional firmware
# - System update and package upgrade via APT
# - Installation of Intel-specific wireless and Realtek firmware
# - Installation of key utilities: sudo, rfkill, and wireless-tools
# - Enabling Wi-Fi functionality
# - Backup and reconstruction of the sudoers file
# - Interactive prompt to add a specified user to the sudoers list
#
# ⚠️ After execution, a system reboot is recommended to apply changes.

echo ""
echo "---------------------------------------------------------------"
echo "This script will perform the following tasks:"
echo "1: Backup the APT sources file and enable non-free repositories"
echo "2: Update and Upgrade all the APT packages"
echo "3: Install missing firmware for Intel Nuc NUC6AYH"
echo "4: Install the sudo, rfkill and wireless-tools packages"
echo "5: Enable the Wi-Fi adapter by installing drivers and software"
echo "6: Backup the sudoers file and ask which user to add to sudoers"
echo "---------------------------------------------------------------"

echo ""
read -p "Press Enter to continue or 'c' to cancel: " user_choice

if [[ "$user_choice" == "c" || "$user_choice" == "C" ]]; then
    echo "Setup canceled by user."
    exit 1
fi

mv /etc/apt/sources.list /etc/apt/sources.list.backup

echo "# deb cdrom:[Debian GNU/Linux 11.5.0 _Bullseye_ - Official amd64 NETINST 20220910-10:38]/ bullseye main" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "#deb cdrom:[Debian GNU/Linux 11.5.0 _Bullseye_ - Official amd64 NETINST 20220910-10:38]/ bullseye main" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian/ bullseye main non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ bullseye main non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://security.debian.org/debian-security bullseye-security main non-free" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/debian-security bullseye-security main non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "# bullseye-updates, to get updates before a point release is made;" >> /etc/apt/sources.list
echo "# see https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian/ bullseye-updates main non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian/ bullseye-updates main non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "# This system was installed using small removable media" >> /etc/apt/sources.list
echo "# (e.g. netinst, live or single CD). The matching "deb cdrom"" >> /etc/apt/sources.list
echo "# entries were disabled at the end of the installation process." >> /etc/apt/sources.list
echo "# For information about how to configure apt package sources," >> /etc/apt/sources.list
echo "# see the sources.list(5) manual." >> /etc/apt/sources.list

apt update
apt upgrade -y
# Optionsl additional firmware installers
# firmware-intel* firmware-linux-nonfree firmware-misc-nonfree 
apt install firmware-iwlwifi firmware-realtek sudo rfkill wireless-tools -y

mv /etc/sudoers /etc/sudoers.backup

echo "#" >> /etc/sudoers
echo "# This file MUST be edited with the 'visudo' command as root." >> /etc/sudoers
echo "#" >> /etc/sudoers
echo "# Please consider adding local content in /etc/sudoers.d/ instead of" >> /etc/sudoers
echo "# directly modifying this file." >> /etc/sudoers
echo "#" >> /etc/sudoers
echo "# See the man page for details on how to write a sudoers file." >> /etc/sudoers
echo "#" >> /etc/sudoers
echo "Defaults	env_reset" >> /etc/sudoers
echo "Defaults	mail_badpass" >> /etc/sudoers
echo 'Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' >> /etc/sudoers
echo "" >> /etc/sudoers
echo "# Host alias specification" >> /etc/sudoers
echo "" >> /etc/sudoers
echo "# User alias specification" >> /etc/sudoers
echo "" >> /etc/sudoers
echo "# Cmnd alias specification" >> /etc/sudoers
echo "" >> /etc/sudoers
echo "# User privilege specification" >> /etc/sudoers
echo "root	ALL=(ALL:ALL) ALL" >> /etc/sudoers

read -p 'User to add to Sudoers: ' USERNAME
echo "$USERNAME      ALL=(ALL:ALL) ALL" >> /etc/sudoers

echo "" >> /etc/sudoers
echo "# Allow members of group sudo to execute any command" >> /etc/sudoers
echo "%sudo	ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "" >> /etc/sudoers
echo "# See sudoers(5) for more information on "@include" directives:" >> /etc/sudoers
echo "" >> /etc/sudoers
echo "@includedir /etc/sudoers.d" >> /etc/sudoers

echo ""
echo "----------------------------------------"
echo "Setup has finished running."
echo "Check sudo privaleges for $USERNAME user"
echo ""
echo "PLEASE REBOOT THE SYSTEM NOW"
echo "----------------------------------------"