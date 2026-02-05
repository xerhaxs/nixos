#!/usr/bin/env bash

 

# Color definitions

RED='\033[0;31m'

GREEN='\033[0;32m'

YELLOW='\033[1;33m'

BLUE='\033[0;34m'

MAGENTA='\033[0;35m'

CYAN='\033[0;36m'

BOLD='\033[1m'

NC='\033[0m' # No Color

 

# Global variables

CHOSEN_DRIVE=""

CHOSEN_HOST=""

DISKPASS=""

WIPE=false

FLAKE_REPO="github:xerhaxs/nixos/main"

 

# Print functions

print_header() {

    echo -e "

${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    echo -e "${BOLD}${BLUE}  $1${NC}"

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}

"

}

 

print_info() {

    echo -e "${BLUE}ℹ${NC}  $1"

}

 

print_success() {

    echo -e "${GREEN}✓${NC}  $1"

}

 

print_error() {

    echo -e "${RED}✗${NC}  $1"

}

 

print_warning() {

    echo -e "${YELLOW}⚠${NC}  $1"

}

 

print_step() {

    echo -e "

${BOLD}${MAGENTA}▶${NC} ${BOLD}$1${NC}"

}

 

# Exit handler

cleanup_and_exit() {

    echo -e "

"

    print_warning "Installation cancelled by user."

    # Clear sensitive variables

    PASSWORD=""

    PASSWORD_CHECK=""

    DISKPASS=""

    ROOTPASS=""

    USERPASS=""

    exit 0

}

 

# Trap CTRL+C

trap cleanup_and_exit INT

 

# Check root privileges

check_root() {

    if [ "$(id -u)" != "0" ]; then

        print_error "This script requires root privileges to run."

        echo -e "    Please run with: ${BOLD}sudo $0${NC}"

        exit 1

    fi

}

 

# Welcome screen

show_welcome() {

    clear

    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"

    echo -e "${CYAN}║                                                                      ║${NC}"

    echo -e "${CYAN}║${NC}              ${BOLD}${BLUE}NixOS Installation Script${NC}                              ${CYAN}║${NC}"

    echo -e "${CYAN}║${NC}                     ${YELLOW}Version 2.0${NC}                                     ${CYAN}║${NC}"

    echo -e "${CYAN}║                                                                      ║${NC}"

    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"

    echo -e "

${BOLD}Welcome!${NC} This script will guide you through the NixOS installation.

"

    echo -e "You can cancel the installation at any time by pressing ${BOLD}CTRL+C${NC}

"

 

    read -p "Press [Enter] to continue or [CTRL+C] to exit..."

}

 

# Install prerequisites

install_prerequisites() {

    print_step "Installing prerequisites..."

    nix-env -iA nixos.git nixos.openssl nixos.jq &>/dev/null

    if [ $? -eq 0 ]; then

        print_success "Prerequisites installed"

    else

        print_error "Failed to install prerequisites"

        exit 1

    fi

 

    print_info "Setting keyboard layout to German..."

    loadkeys de

    print_success "Keyboard layout set"

}

 

# Get available hosts from flake

get_available_hosts() {

    print_step "Fetching available hosts from flake..."

 

    # Try to get hosts from the flake

    local hosts_output

    hosts_output=$(nix flake show "$FLAKE_REPO" --json 2>/dev/null | jq -r '.nixosConfigurations | keys[]' 2>/dev/null)

 

    if [ -z "$hosts_output" ]; then

        print_warning "Could not fetch hosts from flake. Using fallback list."

        # Fallback hosts if flake query fails

        echo "NixOS-Convertible

NixOS-Desktop

NixOS-Framework

NixOS-Server1

NixOS-Server2

NixOS-Server3

NixOS-ServerPublic

NixOS-VMDesktop

NixOS-VMServer"

    else

        echo "$hosts_output"

    fi

}

 

# Select host

select_host() {

    print_header "Host Selection"

 

    local hosts

    hosts=$(get_available_hosts)

 

    if [ -z "$hosts" ]; then

        print_error "No hosts found in flake"

        exit 1

    fi

 

    echo -e "${BOLD}Available hosts:${NC}

"

 

    # Convert hosts to array and display

    local host_array=()

    local i=1

    while IFS= read -r host; do

        echo -e "  ${CYAN}[$i]${NC} $host"

        host_array+=("$host")

        ((i++))

    done <<< "$hosts"

 

    echo ""

    while true; do

        read -p "Select host number (1-${#host_array[@]}): " selection

 

        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#host_array[@]}" ]; then

            CHOSEN_HOST="${host_array[$((selection-1))]}"

            print_success "Selected host: ${BOLD}$CHOSEN_HOST${NC}"

            break

        else

            print_error "Invalid selection. Please enter a number between 1 and ${#host_array[@]}"

        fi

    done

}

 

# Select installation disk

select_installation_disk() {

    print_header "Disk Selection"

 

    echo -e "${BOLD}Available disks:${NC}

"

 

    # Get disk information

    local disk_array=()

    local i=1

 

    while IFS= read -r line; do

        local disk=$(echo "$line" | awk '{print $1}')

        local size=$(echo "$line" | awk '{print $4}')

        local model=$(lsblk -ndo MODEL "/dev/$disk" 2>/dev/null | sed 's/^[ \t]*//;s/[ \t]*$//')

 

        echo -e "  ${CYAN}[$i]${NC} /dev/$disk - ${size}B ${model:+(${model})}"

        disk_array+=("/dev/$disk")

        ((i++))

    done < <(lsblk -ndo NAME,SIZE | grep -E '^(sd|nvme|vd)')

 

    echo ""

    while true; do

        read -p "Select disk number (1-${#disk_array[@]}): " selection

 

        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#disk_array[@]}" ]; then

            CHOSEN_DRIVE="${disk_array[$((selection-1))]}"

            print_success "Selected disk: ${BOLD}$CHOSEN_DRIVE${NC}"

            break

        else

            print_error "Invalid selection. Please enter a number between 1 and ${#disk_array[@]}"

        fi

    done

}

 

# Ask for disk wipe

select_disk_wipe() {

    print_header "Disk Wipe Option"

 

    print_warning "Secure disk wiping will overwrite all data multiple times."

    echo -e "This process can take ${BOLD}several hours${NC} depending on disk size.

"

 

    while true; do

        read -p "Do you want to securely wipe the disk? [y/N]: " response

        case "$response" in

            [yY]|[yY][eE][sS])

                WIPE=true

                print_info "Disk will be securely wiped"

                break

                ;;

            [nN]|[nN][oO]|"")

                WIPE=false

                print_info "Disk will not be wiped"

                break

                ;;

            *)

                print_error "Please answer with 'y' or 'n'"

                ;;

        esac

    done

}

 

# Password input function

read_password() {

    local prompt="$1"

    local password

 

    echo -n "$prompt"

    read -s password

    echo

    echo "$password"

}

 

# Set disk encryption password

select_security() {

    print_header "Disk Encryption"

 

    echo -e "Please set a ${BOLD}strong password${NC} for disk encryption.

"

 

    while true; do

        local pass1=$(read_password "Enter disk password: ")

        local pass2=$(read_password "Confirm disk password: ")

 

        if [ "$pass1" = "$pass2" ]; then

            if [ -z "$pass1" ]; then

                print_error "Password cannot be empty"

            else

                DISKPASS="$pass1"

                print_success "Disk password set successfully"

                break

            fi

        else

            print_error "Passwords do not match. Please try again."

        fi

    done

}

 

# Confirmation screen

show_confirmation() {

    print_header "Installation Summary"

 

    echo -e "${BOLD}Please review your installation settings:${NC}

"

    echo -e "  ${CYAN}Host:${NC}         $CHOSEN_HOST"

    echo -e "  ${CYAN}Disk:${NC}         $CHOSEN_DRIVE"

    echo -e "  ${CYAN}Secure Wipe:${NC}  $([ "$WIPE" = true ] && echo "Yes" || echo "No")"

    echo -e "  ${CYAN}Encryption:${NC}   Enabled"

    echo -e "  ${CYAN}Flake:${NC}        $FLAKE_REPO#$CHOSEN_HOST"

 

    echo -e "

${YELLOW}${BOLD}WARNING:${NC} ${YELLOW}This will destroy all data on $CHOSEN_DRIVE${NC}

"

 

    while true; do

        read -p "Do you want to proceed with the installation? [y/N]: " response

        case "$response" in

            [yY]|[yY][eE][sS])

                return 0

                ;;

            [nN]|[nN][oO]|"")

                cleanup_and_exit

                ;;

            *)

                print_error "Please answer with 'y' or 'n'"

                ;;

        esac

    done

}

 

# Perform disk wipe

wipe_disk() {

    if [ "$WIPE" = true ]; then

        print_step "Securely wiping disk (this may take a long time)..."

        echo -e "${YELLOW}Do not interrupt this process!${NC}

"

 

        shred -v -n 3 -z "$CHOSEN_DRIVE"

 

        if [ $? -eq 0 ]; then

            print_success "Disk wiped successfully"

        else

            print_error "Disk wipe failed"

            exit 1

        fi

    fi

}

 

# Main installation

perform_installation() {

    print_header "Starting Installation"

 

    # Generate encryption keys

    print_step "Generating encryption keys..."

    openssl genrsa -out /tmp/keyfile.key 4096 2>/dev/null

    echo -n "$DISKPASS" > /tmp/secret.key

    print_success "Encryption keys generated"

 

    # Run disko

    print_step "Partitioning and formatting disk..."

    INSTALLATION_TARGET="$FLAKE_REPO#$CHOSEN_HOST"

 

    nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \

        --mode disko --flake "$INSTALLATION_TARGET"

 

    if [ $? -eq 0 ]; then

        print_success "Disk partitioned and formatted"

    else

        print_error "Disk partitioning failed"

        exit 1

    fi

 

    # Move keys to the new system

    print_step "Installing encryption keys..."

    mkdir -p /mnt/root/.secrets

 

    mv /tmp/secret.key /mnt/root/.secrets/secret.key

    chmod 0400 /mnt/root/.secrets/secret.key

    chown root:root /mnt/root/.secrets/secret.key

 

    mv /tmp/keyfile.key /mnt/root/.secrets/keyfile.key

    chmod 0400 /mnt/root/.secrets/keyfile.key

    chown root:root /mnt/root/.secrets/keyfile.key

 

    print_success "Encryption keys installed"

 

    # Generate hardware configuration

    print_step "Generating hardware configuration..."

    nixos-generate-config --root /mnt

    print_success "Hardware configuration generated"

 

    # Install NixOS

    print_step "Installing NixOS (this may take a while)..."

    nixos-install --no-root-passwd --impure --keep-going --flake "$INSTALLATION_TARGET"

 

    if [ $? -eq 0 ]; then

        print_success "NixOS installed successfully!"

    else

        print_error "NixOS installation failed"

        exit 1

    fi

 

    # Clear sensitive variables

    DISKPASS=""

}

 

# Completion screen

show_completion() {

    print_header "Installation Complete!"

 

    echo -e "${GREEN}${BOLD}Congratulations!${NC} NixOS has been successfully installed.

"

    echo -e "The system is ready to use. You can now reboot.

"

 

    while true; do

        read -p "Would you like to reboot now? [Y/n]: " response

        case "$response" in

            [yY]|[yY][eE][sS]|"")

                print_info "Rebooting system..."

                sleep 2

                umount -a 2>/dev/null

                systemctl reboot --now

                ;;

            [nN]|[nN][oO])

                print_info "You can reboot later with: ${BOLD}systemctl reboot${NC}"

                exit 0

                ;;

            *)

                print_error "Please answer with 'y' or 'n'"

                ;;

        esac

    done

}

 

# Main execution

main() {

    check_root

    show_welcome

    install_prerequisites

    select_host

    select_installation_disk

    select_disk_wipe

    select_security

    show_confirmation

    wipe_disk

    perform_installation

    show_completion

}

 

# Run main function

main