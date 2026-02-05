#!/usr/bin/env bash
set -euo pipefail

### Catppuccin Mocha Colors ###
MAUVE='\033[38;2;203;166;247m'
BLUE='\033[38;2;137;180;250m'
GREEN='\033[38;2;166;227;161m'
YELLOW='\033[38;2;249;226;175m'
RED='\033[38;2;243;139;168m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT='\033[38;2;166;173;200m'
NC='\033[0m'

### Globals ###
FLAKE_REPO="github:xerhaxs/nixos/main"
CHOSEN_HOST=""
CHOSEN_DRIVE=""
DISKPASS=""
WIPE=false

abort() {
    echo -e "\n${RED}Installation aborted by user.${NC}"
    exit 1
}
trap abort INT TERM

header() {
    echo -e "\n${MAUVE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${TEXT}$1${NC}"
    echo -e "${MAUVE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

prompt_password() {
    while true; do
        read -rs -p "$1: " pass1; echo
        read -rs -p "Confirm $1: " pass2; echo
        if [[ -z "$pass1" ]]; then
            echo -e "${RED}Password cannot be empty.${NC}"
        elif [[ "$pass1" == "$pass2" ]]; then
            echo "$pass1"
            break
        else
            echo -e "${RED}Passwords do not match. Try again.${NC}"
        fi
    done
}

require_root() {
    if [[ $(id -u) -ne 0 ]]; then
        echo -e "${RED}Root privileges required.${NC}"
        exit 1
    fi
}

# ------------------ Host Selection ------------------
get_hosts_from_flake() {
    nix --extra-experimental-features "nix-command flakes" eval "$FLAKE_REPO#nixosConfigurations" --raw
}

select_host() {
    header "Select NixOS Host"

    HOSTS_RAW=$(get_hosts_from_flake)
    if [[ -z "$HOSTS_RAW" ]]; then
        echo -e "${RED}No hosts found in the flake.${NC}"
        exit 1
    fi

    IFS=$'\n' read -r -d '' -a HOSTS <<< "$HOSTS_RAW"$'\0'

    for i in "${!HOSTS[@]}"; do
        echo -e "${BLUE}[$((i+1))]${NC} ${TEXT}${HOSTS[$i]}${NC}"
    done

    while true; do
        read -rp "Select host number: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#HOSTS[@]})); then
            CHOSEN_HOST="${HOSTS[$((choice-1))]}"
            echo -e "${GREEN}Selected host: $CHOSEN_HOST${NC}"
            break
        else
            echo -e "${RED}Invalid choice. Try again.${NC}"
        fi
    done
}

# ------------------ Disk Selection ------------------
select_disk() {
    header "Select Installation Disk"
    mapfile -t DISKS < <(lsblk -dn -o NAME,TYPE | awk '$2=="disk"{print $1}')
    if [[ ${#DISKS[@]} -eq 0 ]]; then
        echo -e "${RED}No disks found.${NC}"
        exit 1
    fi

    for i in "${!DISKS[@]}"; do
        SIZE=$(lsblk -dn -o SIZE "/dev/${DISKS[$i]}")
        echo -e "${BLUE}[$((i+1))]${NC} /dev/${DISKS[$i]} (${SIZE})"
    done

    while true; do
        read -rp "Select disk number: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#DISKS[@]})); then
            CHOSEN_DRIVE="/dev/${DISKS[$((choice-1))]}"
            echo -e "${GREEN}Selected disk: $CHOSEN_DRIVE${NC}"
            break
        else
            echo -e "${RED}Invalid choice. Try again.${NC}"
        fi
    done
}

select_disk_wipe() {
    header "Secure Disk Wipe"
    read -rp "Do you want to securely wipe the disk? [y/N]: " response
    if [[ "$response" =~ ^[yY] ]]; then
        WIPE=true
        echo -e "${YELLOW}Disk will be wiped.${NC}"
    else
        WIPE=false
        echo -e "${SUBTEXT}Disk will not be wiped.${NC}"
    fi
}

set_disk_password() {
    header "Disk Encryption Password"
    DISKPASS=$(prompt_password "Enter disk password")
}

confirm_installation() {
    header "Installation Summary"
    echo -e "${TEXT}Host:${NC} $CHOSEN_HOST"
    echo -e "${TEXT}Disk:${NC} $CHOSEN_DRIVE"
    echo -e "${TEXT}Secure Wipe:${NC} $WIPE"
    echo -e "${TEXT}Disk Encryption:${NC} Enabled"
    read -rp "Proceed with installation? [y/N]: " response
    if [[ ! "$response" =~ ^[yY] ]]; then
        abort
    fi
}

wipe_disk() {
    if [[ "$WIPE" == true ]]; then
        header "Wiping Disk"
        shred -v -n 3 -z "$CHOSEN_DRIVE"
    fi
}

install_nixos() {
    header "Installing NixOS"

    openssl genrsa -out /tmp/keyfile.key 4096
    echo -n "$DISKPASS" > /tmp/secret.key

    INSTALLATION_TARGET="$FLAKE_REPO#$CHOSEN_HOST"

    nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
        --mode disko --flake "$INSTALLATION_TARGET"

    mkdir -p /mnt/root/.secrets
    mv /tmp/secret.key /mnt/root/.secrets/secret.key
    chmod 0400 /mnt/root/.secrets/secret.key
    chown root:root /mnt/root/.secrets/secret.key

    mv /tmp/keyfile.key /mnt/root/.secrets/keyfile.key
    chmod 0400 /mnt/root/.secrets/keyfile.key
    chown root:root /mnt/root/.secrets/keyfile.key

    nixos-generate-config --root /mnt
    nixos-install --no-root-passwd --impure --keep-going --flake "$INSTALLATION_TARGET"

    # Clear sensitive variables
    DISKPASS=""
}

main() {
    require_root
    select_host
    select_disk
    select_disk_wipe
    set_disk_password
    confirm_installation
    wipe_disk
    install_nixos
}

main