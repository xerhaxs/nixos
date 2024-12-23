#!/usr/bin/env sh

# Check whether the script is executed with root privileges
if [ "$(id -u)" != "0" ]; then
    echo "The script requires root privileges to run."
    exit 1
fi

# Simple NixOS installation script
sudo nix-env -iA nixos.newt nixos.openssl

sudo loadkeys de

## Function to detect and set a password
function_password() {
	function_set_password() {
		PASSWORD=$(whiptail --nocancel --title "Set password" --passwordbox "Chose a strong password." 32 128 3>&1 1>&2 2>&3)

		PASSWORD_CHECK=$(whiptail --nocancel --title "Confirm password" --passwordbox "Type your password again to confirm." 32 128 3>&1 1>&2 2>&3)
	}

	function_set_password
	PASSWORD_SET=false

	while [[ $PASSWORD_SET = false ]]; do
		if [[ $PASSWORD == $PASSWORD_CHECK ]]; then
			PASSWORD_SET=true
			echo "$PASSWORD"
		else
			whiptail --nocancel --title "Incorrect Password" --msgbox "The passwords do not match. Please try again." 32 128 3>&1 1>&2 2>&3
			function_set_password
		fi
	done
}

## Function to set installation disk
function_select_installation_disk() {
	DISKS=$(lsblk | grep disk | awk '{print $1}')

	DISK_OPTIONS=()
	for DISK in $DISKS; do
		DISK_SIZE=$(lsblk "/dev/$DISK" | grep disk | awk '{print $4}')
		DISK_OPTIONS+=("/dev/$DISK" "$DISK_SIZE")
	done

	CHOSEN_DRIVE=$(whiptail --nocancel --title "Menu selected Drive" --menu "Where should NixOS be installed?" 32 128 16 "${DISK_OPTIONS[@]}" 3>&1 1>&2 2>&3)

	echo "$CHOSEN_DRIVE"
}

function_select_disk_wipe() {
	whiptail --title "Securely disk wipe " --yesno "Do you want to securely wipe the disk?" 32 128 3>&1 1>&2 2>&3
	if [[ $? -eq 0 ]]; then
			WIPE=true
		else
			WIPE=false
	fi
}

function_select_security() {
    whiptail --nocancel --title "Disk password" --msgbox "In the following, set a secure password for the installation disk." 32 128 3>&1 1>&2 2>&3
	DISKPASS=$(function_password)
}

## Function to set the root credentials
function_select_root_credentials() {
	whiptail --nocancel --title "Root password" --msgbox "In the following, set a secure root password." 32 128 3>&1 1>&2 2>&3
	ROOTPASS=$(function_password)
}

## Function to set the user credentials
function_select_user_credentials() {
	CHROOTUSERNAME=$(whiptail --nocancel --title "Create User" --inputbox "Chose your username (only lowercase letters, numbers and no spaces or special characters) and set a secure password." 32 128 3>&1 1>&2 2>&3)

	USERPASS=$(function_password)
}

# Function to set the host
function_select_host() {
    CHOSEN_HOST=$(whiptail --nocancel --title "Host System" --menu "Chose which host system to install." 32 128 10 \
		"NixOS-Convertible" "Configuration for Convertible" \
        "NixOS-Crafter" "Configuration for Workshop" \
        "NixOS-Desktop" "Configuration for Desktop PC" \
        "NixOS-Framework" "Configuration for Framework Laptop" \
        "NixOS-Laptop" "Configuration for Laptop" \
		"NixOS-Live" "Configuration for Live Setup" \
        "NixOS-Server1" "Configuration for Server1" \
		"NixOS-Server2" "Configuration for Server2" \
		"NixOS-Server3" "Configuration for Server3" \
        "NixOS-Test" "Configuration for Test" \
		3>&1 1>&2 2>&3)

	echo "$CHOSEN_HOST"
}

# Call the functions
#function_select_installation_disk

#function_select_disk_wipe

function_select_security

#function_select_root_credentials

function_select_host

#function_select_user_credentials


## Wipe the disk
if [[ $WIPE = true ]]; then
	echo "Wiping disk..."
	sudo dd if=/dev/zero of=$CHOSEN_DRIVE status=progress
fi

# Create keyfile for encryption without password
sudo openssl genrsa -out /tmp/keyfile.key 4096

sudo echo -n "$DISKPASS" > /tmp/secret.key
INSTALLATION_TARGET="github:xerhaxs/nixos/main#$CHOSEN_HOST"
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake $INSTALLATION_TARGET

sudo mkdir /mnt/root

sudo mv /tmp/secret.key /mnt/root/secret.key
sudo chmod -v 0400 /mnt/root/secret.key
sudo chown root:root /mnt/root/secret.key

sudo mv /tmp/keyfile.key /mnt/root/keyfile.key
sudo chmod -v 0400 /mnt/root/keyfile.key
sudo chown root:root /mnt/root/keyfile.key

sudo nixos-generate-config --root /mnt
#sudo nixos-install --no-root-passwd
sudo nixos-install --no-root-passwd --impure --keep-going --flake $INSTALLATION_TARGET

PASSWORD="";
PASSWORD_CHECK="";
DISKPASS="";
ROOTPASS="";
USERPASS="";

## Reboot system
#whiptail --title "Installation is complete" --yesno "Restart computer?" 32 128 3>&1 1>&2 2>&3

	#if [[ $? -eq 0 ]]; then
	#	    umount -a
	 #   	systemctl reboot --now
   	#elif [[ $? -eq 1 ]]; then
	#		whiptail --title "MESSAGE" --msgbox "Cancelling Process since user pressed <NO>. Returned to shell." 32 128 3>&1 1>&2 2>&3
	 #   elif [[ $? -eq 255 ]]; then
	  #      whiptail --title "MESSAGE" --msgbox "User pressed ESC. Returned to shell." 32 128 3>&1 1>&2 2>&3
#fi
