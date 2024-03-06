#!/usr/bin/env sh

# Check whether the script is executed with root privileges
if [ "$(id -u)" != "0" ]; then
    echo "The script requires root privileges to run."
    exit 1
fi

# Simple NixOS installation script
nix-env -iA nixos.newt

loadkeys de

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
        "NixOS-Crafter" "Configuration for Workshop" \
        "NixOS-Desktop" "Configuration for Desktop PC" \
        "NixOS-Gaming" "Configuration for Gaming PC" \
        "NixOS-Laptop" "Configuration for Laptop" \
        "NixOS-Server" "Configuration for Server" \
        "NixOS-Testing" "Configuration for Testing" \
		3>&1 1>&2 2>&3)

	echo "$CHOSEN_HOST"
}

# Call the functions
function_select_installation_disk

function_select_disk_wipe

function_select_security

#function_select_root_credentials

function_select_host

#function_select_user_credentials




## Wipe the disk
if [[ $WIPE = true ]]; then
	echo "Wiping disk..."
	dd if=/dev/zero of=$CHOSEN_DRIVE status=progress
fi

## Load encryptin tools
modprobe dm-crypt
	
# Test if UEFI or Legacy-Bios System and create parition type
if [ -d "/sys/firmware/efi" ]; then
    echo "UEFI-System"
    BIOS_TYPE="UEFI"
    yes | parted $CHOSEN_DRIVE mklabel gpt
    parted $CHOSEN_DRIVE mkpart primary fat32 1MiB 513MiB
    parted $CHOSEN_DRIVE set 1 esp on
    parted $CHOSEN_DRIVE --script mkpart primary ext4 513MiB 100%
else
    echo "Legacy-BIOS-System"
    BIOS_TYPE="Legacy"
	yes | parted $CHOSEN_DRIVE mklabel msdos
	parted $CHOSEN_DRIVE mkpart primary fat32 2049KiB 513MiB
	parted $CHOSEN_DRIVE set 1 boot on
	parted $CHOSEN_DRIVE --script mkpart primary ext4 513MiB 100%
fi

## Create Crypt + Boot partition

# Init boot + crypt drive
if [[ $CHOSEN_DRIVE == *"nvme"* ]]; then 
		BOOT_DRIVE=$CHOSEN_DRIVE"p1"
		CRYPT_DRIVE=$CHOSEN_DRIVE"p2"
	else
		BOOT_DRIVE=$CHOSEN_DRIVE"1"
		CRYPT_DRIVE=$CHOSEN_DRIVE"2"
fi
	
# Encrypt second partition
echo "$DISKPASS" | cryptsetup --batch-mode --cipher aes-xts-plain64 --key-size 512 --hash sha512 luksFormat $CRYPT_DRIVE --label CRYPTDRIVE

# Open encrypted partition
echo "$DISKPASS" | cryptsetup luksOpen $CRYPT_DRIVE lvm

# Create root + home volume
pvcreate /dev/mapper/lvm
vgcreate crypt /dev/mapper/lvm
lvcreate -l 50%FREE -n root crypt
lvcreate -l 100%FREE -n home crypt

# Init crypt root and crypt home
CRYPT_ROOT_DRIVE="/dev/mapper/crypt-root"
CRYPT_HOME_DRIVE="/dev/mapper/crypt-home"

# Create file system
mkfs.fat -F 32 -n UEFI $BOOT_DRIVE
mkfs.ext4 -L root $CRYPT_ROOT_DRIVE
mkfs.ext4 -L home $CRYPT_HOME_DRIVE

# Mount the file system
mount $CRYPT_ROOT_DRIVE /mnt/
mkdir /mnt/boot
mount $BOOT_DRIVE /mnt/boot
mkdir /mnt/home
mount $CRYPT_HOME_DRIVE /mnt/home

# Generate NixOS Config
#nixos-generate-config --root /mnt
mkdir -p /mnt/etc/nixos/
cp -R ../nixos/* /mnt/etc/nixos/
#echo "$ROOTPASS" | nixos-install --impure --flake /mnt/etc/nixos/$CHOSEN_HOST
nixos-install --no-root-passwd --impure --flake /mnt/etc/nixos#$CHOSEN_HOST

PASSWORD="";
PASSWORD_CHECK="";
DISKPASS="";
ROOTPASS="";
USERPASS="";

## Reboot system
whiptail --title "Installation is complete" --yesno "Restart computer?" 32 128 3>&1 1>&2 2>&3

	if [[ $? -eq 0 ]]; then
		    umount -a
	    	systemctl reboot --now
    	elif [[ $? -eq 1 ]]; then
			whiptail --title "MESSAGE" --msgbox "Cancelling Process since user pressed <NO>. Returned to shell." 32 128 3>&1 1>&2 2>&3
	    elif [[ $? -eq 255 ]]; then
	        whiptail --title "MESSAGE" --msgbox "User pressed ESC. Returned to shell." 32 128 3>&1 1>&2 2>&3
fi
