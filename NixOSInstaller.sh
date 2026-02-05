#!/usr/bin/env bash
set -euo pipefail

### Catppuccin Mocha Colors ###
ROSEWATER='\033[38;2;245;224;220m'
FLAMINGO='\033[38;2;242;205;205m'
PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
RED='\033[38;2;243;139;168m'
MAROON='\033[38;2;235;160;172m'
PEACH='\033[38;2;250;179;135m'
YELLOW='\033[38;2;249;226;175m'
GREEN='\033[38;2;166;227;161m'
TEAL='\033[38;2;148;226;213m'
SKY='\033[38;2;137;220;235m'
SAPPHIRE='\033[38;2;116;199;236m'
BLUE='\033[38;2;137;180;250m'
LAVENDER='\033[38;2;180;190;254m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT='\033[38;2;166;173;200m'
SURFACE='\033[38;2;49;50;68m'
NC='\033[0m'

### Globals ###
CHOSEN_DRIVE=""
CHOSEN_HOST=""
DISKPASS=""
WIPE=false
FLAKE_REPO="github:xerhaxs/nixos/main"

cleanup_and_exit() {
    DISKPASS=""
    echo -e "${YELLOW}Installation aborted.${NC}"
    exit 1
}
trap cleanup_and_exit INT

check_root() {
    if [[ $(id -u) -ne 0 ]]; then
        echo -e "${RED}Root privileges are required.${NC}"
        exit 1
    fi
}

header() {
    echo -e "\n${MAUVE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${LAVENDER}$1${NC}"
    echo -e "${MAUVE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

info() { echo -e "${BLUE}$1${NC}"; }
ok()   { echo -e "${GREEN}$1${NC}"; }
err()  { echo -e "${RED}$1${NC}"; }

install_prerequisites() {
    header "Installing prerequisites"
    nix-env -iA nixos.git nixos.openssl nixos.jq >/dev/null
    loadkeys de
    ok "Prerequisites installed"
}

get_available_hosts() {
    nix flake show "$FLAKE_REPO" --json 2>/dev/null \
        | jq -r '.nixosConfigurations | keys[]' || true
}

select_host() {
    header "Host selection"
    mapfile -t HOSTS < <(get_available_hosts)

    [[ ${#HOSTS[@]} -gt 0 ]] || { err "No hosts found."; exit 1; }

    for i in "${!HOSTS[@]}"; do
        echo -e "${SUBTEXT}[$((i+1))]${NC} ${HOSTS[$i]}"
    done

    while true; do
        read -r -p "Select host number: " n
        [[ "$n" =~ ^[0-9]+$ ]] && ((n>=1 && n<=${#HOSTS[@]})) && break
    done

    CHOSEN_HOST="${HOSTS[$((n-1))]}"
    ok "Selected host: $CHOSEN_HOST"
}

select_installation_disk() {
    header "Disk selection"
    mapfile -t DISKS < <(lsblk -ndo NAME,TYPE | awk '$2=="disk"{print $1}')

    [[ ${#DISKS[@]} -gt 0 ]] || { err "No disks found."; exit 1; }

    for i in "${!DISKS[@]}"; do
        SIZE=$(lsblk -ndo SIZE "/dev/${DISKS[$i]}")
        MODEL=$(lsblk -ndo MODEL "/dev/${DISKS[$i]}")
        echo -e "${SUBTEXT}[$((i+1))]${NC} /dev/${DISKS[$i]} ${SIZE} ${MODEL}"
    done

    while true; do
        read -r -p "Select disk number: " n
        [[ "$n" =~ ^[0-9]+$ ]] && ((n>=1 && n<=${#DISKS[@]})) && break
    done

    CHOSEN_DRIVE="/dev/${DISKS[$((n-1))]}"
    ok "Selected disk: $CHOSEN_DRIVE"
}

select_disk_wipe() {
    header "Secure wipe"
    read -r -p "Securely wipe disk? [y/N]: " a
    [[ "$a" =~ ^[yY] ]] && WIPE=true || WIPE=false
}

read_password() {
    local p
    read -rs -p "$1" p
    echo
    echo "$p"
}

select_security() {
    header "Disk encryption password"
    while true; do
        local p1 p2
        p1=$(read_password "Enter password: ")
        p2=$(read_password "Confirm password: ")
        [[ -n "$p1" && "$p1" == "$p2" ]] && break
        err "Passwords do not match."
    done
    DISKPASS="$p1"
    ok "Password set"
}

confirm() {
    header "Installation summary"
    echo -e "${TEXT}Host:${NC} $CHOSEN_HOST"
    echo -e "${TEXT}Disk:${NC} $CHOSEN_DRIVE"
    echo -e "${TEXT}Secure wipe:${NC} $WIPE"
    read -r -p "Proceed with installation? [y/N]: " a
    [[ "$a" =~ ^[yY] ]] || cleanup_and_exit
}

wipe_disk() {
    [[ "$WIPE" == true ]] || return
    header "Wiping disk"
    shred -v -n 3 -z "$CHOSEN_DRIVE"
}

install_nixos() {
    header "Installing NixOS"

    openssl genrsa -out /tmp/keyfile.key 4096 >/dev/null
    echo -n "$DISKPASS" > /tmp/secret.key

    nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
        --mode disko --flake "$FLAKE_REPO#$CHOSEN_HOST"

    mkdir -p /mnt/root/.secrets
    install -m 0400 /tmp/secret.key /mnt/root/.secrets/secret.key
    install -m 0400 /tmp/keyfile.key /mnt/root/.secrets/keyfile.key

    nixos-generate-config --root /mnt
    nixos-install --no-root-passwd --impure --keep-going --flake "$FLAKE_REPO#$CHOSEN_HOST"

    ok "Installation completed successfully"
}

main() {
    check_root
    install_prerequisites
    select_host
    select_installation_disk
    select_disk_wipe
    select_security
    confirm
    wipe_disk
    install_nixos
}

main
