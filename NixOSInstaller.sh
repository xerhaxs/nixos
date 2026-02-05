#!/usr/bin/env bash
set -Eeuo pipefail

### Enable flakes for curl | bash ###
export NIX_CONFIG="experimental-features = nix-command flakes"

### Catppuccin Mocha Colors ###
MAUVE='\033[38;2;203;166;247m'
BLUE='\033[38;2;137;180;250m'
GREEN='\033[38;2;166;227;161m'
RED='\033[38;2;243;139;168m'
YELLOW='\033[38;2;249;226;175m'
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
    DISKPASS=""
    echo -e "\n${YELLOW}Aborted by user.${NC}"
    exit 1
}
trap abort INT TERM

header() {
    echo -e "\n${MAUVE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${TEXT}$1${NC}"
    echo -e "${MAUVE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

ok()  { echo -e "${GREEN}$1${NC}"; }
err() { echo -e "${RED}$1${NC}"; }

require_root() {
    [[ $(id -u) -eq 0 ]] || { err "Root privileges required."; exit 1; }
}

install_prerequisites() {
    header "Installing prerequisites"
    nix-env -iA nixos.git nixos.openssl nixos.jq >/dev/null
    loadkeys de
    ok "Prerequisites installed"
}

get_hosts_from_flake() {
    raw_output=$(nix --extra-experimental-features "nix-command flakes" \
        eval --json "${FLAKE_REPO}#nixosConfigurations" 2>&1)
    echo "Raw output from nix eval: $raw_output" >&2
    echo "$raw_output" | jq -r 'keys[]' 2>&1
}

select_host() {
    header "Host selection"

    mapfile -t HOSTS < <(get_hosts_from_flake)
    if [[ ${#HOSTS[@]} -eq 0 ]]; then
        err "No hosts found in flake."
        echo "Debug: No hosts found in flake." >&2
        exit 1
    fi

    for i in "${!HOSTS[@]}"; do
        echo -e "${SUBTEXT}[$((i+1))]${NC} ${HOSTS[$i]}"
    done

    while true; do
        read -r -p "Select host number: " n
        if [[ "$n" =~ ^[0-9]+$ ]] && ((n>=1 && n<=${#HOSTS[@]})); then
            break
        else
            err "Invalid selection. Please enter a number between 1 and ${#HOSTS[@]}."
        fi
    done

    CHOSEN_HOST="${HOSTS[$((n-1))]}"
    ok "Selected host: $CHOSEN_HOST"
}

select_disk() {
    header "Disk selection"

    mapfile -t DISKS < <(lsblk -ndo NAME,TYPE | awk '$2=="disk"{print $1}')
    if [[ ${#DISKS[@]} -eq 0 ]]; then
        err "No disks found."
        exit 1
    fi

    for i in "${!DISKS[@]}"; do
        SIZE=$(lsblk -ndo SIZE "/dev/${DISKS[$i]}")
        MODEL=$(lsblk -ndo MODEL "/dev/${DISKS[$i]}")
        echo -e "${SUBTEXT}[$((i+1))]${NC} /dev/${DISKS[$i]} ${SIZE} ${MODEL}"
    done

    while true; do
        read -r -p "Select disk number: " n
        if [[ "$n" =~ ^[0-9]+$ ]] && ((n>=1 && n<=${#DISKS[@]})); then
            break
        else
            err "Invalid selection. Please enter a number between 1 and ${#DISKS[@]}."
        fi
    done

    CHOSEN_DRIVE="/dev/${DISKS[$((n-1))]}"
    ok "Selected disk: $CHOSEN_DRIVE"
}

select_wipe() {
    header "Secure wipe"
    read -r -p "Securely wipe disk? [y/N]: " a
    if [[ "$a" =~ ^[yY] ]]; then
        WIPE=true
    else
        WIPE=false
    fi
}

read_password() {
    local p
    read -rs -p "$1" p
    echo
    echo "$p"
}

select_disk_password() {
    header "Disk encryption password"

    while true; do
        p1=$(read_password "Enter password: ")
        p2=$(read_password "Confirm password: ")
        if [[ -n "$p1" && "$p1" == "$p2" ]]; then
            break
        else
            err "Passwords do not match."
        fi
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
    if [[ "$a" =~ ^[yY] ]]; then
        return
    else
        abort
    fi
}

wipe_disk() {
    if [[ "$WIPE" == true ]]; then
        header "Wiping disk"
        shred -v -n 3 -z "$CHOSEN_DRIVE"
    fi
}

install_nixos() {
    header "Installing NixOS"

    openssl genrsa -out /tmp/keyfile.key 4096 >/dev/null
    echo -n "$DISKPASS" > /tmp/secret.key

    nix --extra-experimental-features "nix-command flakes" \
        run github:nix-community/disko -- \
        --mode disko --flake "$FLAKE_REPO#$CHOSEN_HOST"

    mkdir -p /mnt/root/.secrets
    install -m 0400 /tmp/secret.key /mnt/root/.secrets/secret.key
    install -m 0400 /tmp/keyfile.key /mnt/root/.secrets/keyfile.key

    nixos-generate-config --root /mnt

    nixos-install --no-root-passwd --impure --keep-going \
        --flake "$FLAKE_REPO#$CHOSEN_HOST"

    ok "Installation finished"
}

main() {
    require_root
    install_prerequisites
    select_host
    select_disk
    select_wipe
    select_disk_password
    confirm
    wipe_disk
    install_nixos
}

main
