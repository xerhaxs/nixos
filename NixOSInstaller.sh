#!/usr/bin/env bash
set -euo pipefail

### Catppuccin-inspired Colors (Basic ANSI) ###
CYAN='\033[1;36m'       # Bright Cyan (Titel, Akzente)
RED='\033[1;31m'        # Bright Red (Fehler)
YELLOW='\033[0;33m'     # Yellow (Warnungen)
GREEN='\033[1;32m'      # Bright Green (Erfolg)
BLUE='\033[1;34m'       # Bright Blue (Prompts)
MAGENTA='\033[0;35m'    # Magenta (Akzente)
TEXT='\033[0;37m'       # White (Text)
SUBTEXT='\033[1;37m'    # Bright White (Hervorgehobener Text)
GRAY='\033[0;90m'       # Dark Gray (Sekundär)
NC='\033[0m'            # No Color
BOLD='\033[1m'
DIM='\033[2m'

### Globals ###
FLAKE_REPO="github:xerhaxs/nixos/main"
CHOSEN_HOST=""
CHOSEN_DRIVE=""
DISKPASS=""
WIPE=false

### Utility Functions ###
abort() {
    echo ""
    print_box_error "Installation aborted by user"
    exit 1
}
trap abort INT TERM

clear_screen() {
    clear
    print_banner
}

print_banner() {
    echo -e "${CYAN}${BOLD}"
    cat << 'EOF'
    ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗
    ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝
    ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗
    ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║
    ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║
    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
EOF
    echo -e "${BLUE}     I N S T A L L E R   S C R I P T${NC}"
    echo -e "${GRAY}=================================================${NC}\n"
}

print_box() {
    local color=$1
    local title=$2
    
    echo -e "${color}╭──────────────────────────────────────────────────╮${NC}"
    echo -e "${color}│${NC} ${BOLD}${SUBTEXT}${title}${NC}$(printf '%*s' $((48 - ${#title})) '')${color}│${NC}"
    echo -e "${color}╰──────────────────────────────────────────────────╯${NC}"
    echo ""
}

print_box_error() {
    local msg=$1
    local padding=$((40 - ${#msg}))
    [[ $padding -lt 0 ]] && padding=0
    echo -e "${RED}╭──────────────────────────────────────────────────╮${NC}"
    echo -e "${RED}│${NC} ${BOLD}${RED}[ERROR] ${msg}${NC}$(printf '%*s' $padding '')${RED}│${NC}"
    echo -e "${RED}╰──────────────────────────────────────────────────╯${NC}"
}

print_box_success() {
    local msg=$1
    local padding=$((38 - ${#msg}))
    [[ $padding -lt 0 ]] && padding=0
    echo -e "${GREEN}╭──────────────────────────────────────────────────╮${NC}"
    echo -e "${GREEN}│${NC} ${BOLD}${GREEN}[SUCCESS] ${msg}${NC}$(printf '%*s' $padding '')${GREEN}│${NC}"
    echo -e "${GREEN}╰──────────────────────────────────────────────────╯${NC}"
}

print_box_warning() {
    local msg=$1
    local padding=$((38 - ${#msg}))
    [[ $padding -lt 0 ]] && padding=0
    echo -e "${YELLOW}╭──────────────────────────────────────────────────╮${NC}"
    echo -e "${YELLOW}│${NC} ${BOLD}${YELLOW}[WARNING] ${msg}${NC}$(printf '%*s' $padding '')${YELLOW}│${NC}"
    echo -e "${YELLOW}╰──────────────────────────────────────────────────╯${NC}"
}

print_box_info() {
    local msg=$1
    local padding=$((43 - ${#msg}))
    [[ $padding -lt 0 ]] && padding=0
    echo -e "${BLUE}╭──────────────────────────────────────────────────╮${NC}"
    echo -e "${BLUE}│${NC} ${BOLD}${BLUE}[INFO] ${msg}${NC}$(printf '%*s' $padding '')${BLUE}│${NC}"
    echo -e "${BLUE}╰──────────────────────────────────────────────────╯${NC}"
}

print_step() {
    local step=$1
    local total=$2
    local desc=$3
    echo -e "${CYAN}[${BLUE}${step}${CYAN}/${BLUE}${total}${CYAN}]${NC} ${TEXT}${desc}${NC}"
}

print_item() {
    local label=$1
    local value=$2
    local color=$3
    echo -e "  ${GRAY}${label}:${NC} ${color}${BOLD}${value}${NC}"
}

prompt_password() {
    local prompt=$1
    while true; do
        echo -e "${BLUE}${prompt}${NC}"
        read -rs -p "   Password: " pass1
        echo ""
        read -rs -p "   Confirm:  " pass2
        echo ""
        
        if [[ -z "$pass1" ]]; then
            print_box_error "Password cannot be empty"
            echo ""
        elif [[ "$pass1" == "$pass2" ]]; then
            echo "$pass1"
            break
        else
            print_box_error "Passwords do not match"
            echo ""
        fi
    done
}

require_root() {
    if [[ $(id -u) -ne 0 ]]; then
        print_box_error "Root privileges required"
        exit 1
    fi
}

press_enter() {
    echo ""
    echo -e "${DIM}${GRAY}Press Enter to continue...${NC}"
    read -r
}

# ------------------ Host Selection ------------------
get_hosts_from_flake() {
    local tmpfile="/tmp/nix_flake_$$.txt"
    
    # Run nix flake show and save output
    nix flake show "$FLAKE_REPO" \
        --extra-experimental-features "nix-command flakes" \
        --accept-flake-config > "$tmpfile" 2>&1
    
    # Extract hosts from the tree structure
    # Looking for lines like "├───NixOS-Desktop" or "└───NixOS-Server"
    local hosts
    hosts=$(grep -E "^[│ ]*[├└]───" "$tmpfile" \
        | grep -A 1 "nixosConfigurations" \
        | grep -E "^[│ ]*[├└]───" \
        | sed 's/^[│ ]*[├└]───//' \
        | sed 's/:.*$//' \
        | awk '{print $1}' \
        | grep -v "^$" \
        | sort -u)
    
    rm -f "$tmpfile"
    
    # Return hosts, one per line
    echo "$hosts"
}

select_host() {
    clear_screen
    print_box "${CYAN}" "Select NixOS Host Configuration"
    
    print_step "1" "6" "Fetching available hosts from flake..."
    echo ""
    
    echo -e "${BLUE}>>>${NC} ${TEXT}Connecting to ${CYAN}${FLAKE_REPO}${TEXT}...${NC}"
    
    local hosts_output
    hosts_output=$(get_hosts_from_flake)
    
    if [[ -z "$hosts_output" ]]; then
        echo ""
        print_box_error "No hosts found in the flake"
        echo ""
        echo -e "${GRAY}Debug: Try manually running:${NC}"
        echo -e "${GRAY}  nix flake show ${FLAKE_REPO}${NC}"
        exit 1
    fi
    
    # Read hosts into array
    declare -a HOSTS=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && HOSTS+=("$line")
    done <<< "$hosts_output"

    if [[ ${#HOSTS[@]} -eq 0 ]]; then
        print_box_error "Failed to parse host list"
        exit 1
    fi

    echo ""
    echo -e "${TEXT}Available configurations:${NC}"
    echo ""
    for i in "${!HOSTS[@]}"; do
        local num=$((i+1))
        echo -e "  ${BLUE}[${BOLD}${num}${NC}${BLUE}]${NC} ${TEXT}${HOSTS[$i]}${NC}"
    done

    echo ""
    local choice
    while true; do
        echo -e "${BLUE}>>>${NC} ${TEXT}Select host number:${NC}"
        read -r choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#HOSTS[@]})); then
            CHOSEN_HOST="${HOSTS[$((choice-1))]}"
            echo ""
            print_box_success "Selected: ${CHOSEN_HOST}"
            break
        else
            echo ""
            print_box_error "Invalid choice. Try again"
            echo ""
        fi
    done
    
    press_enter
}

# ------------------ Disk Selection ------------------
select_disk() {
    clear_screen
    print_box "${YELLOW}" "Select Installation Disk"
    
    print_step "2" "6" "Scanning available disks..."
    echo ""
    
    mapfile -t DISKS < <(lsblk -dn -o NAME,TYPE | awk '$2=="disk"{print $1}')
    
    if [[ ${#DISKS[@]} -eq 0 ]]; then
        print_box_error "No disks found"
        exit 1
    fi

    echo -e "${TEXT}Available disks:${NC}"
    echo ""
    for i in "${!DISKS[@]}"; do
        local num=$((i+1))
        local disk="${DISKS[$i]}"
        local size=$(lsblk -dn -o SIZE "/dev/${disk}")
        local model=$(lsblk -dn -o MODEL "/dev/${disk}" 2>/dev/null | xargs || echo "Unknown")
        
        echo -e "  ${BLUE}[${BOLD}${num}${NC}${BLUE}]${NC} ${YELLOW}/dev/${disk}${NC}"
        echo -e "      ${GRAY}Size: ${size}${NC}"
        echo -e "      ${GRAY}Model: ${model}${NC}"
        echo ""
    done

    local choice
    while true; do
        echo -e "${BLUE}>>>${NC} ${TEXT}Select disk number:${NC}"
        read -r choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#DISKS[@]})); then
            CHOSEN_DRIVE="/dev/${DISKS[$((choice-1))]}"
            echo ""
            print_box_warning "Selected: ${CHOSEN_DRIVE}"
            print_box_warning "ALL DATA WILL BE DESTROYED!"
            break
        else
            echo ""
            print_box_error "Invalid choice. Try again"
            echo ""
        fi
    done
    
    press_enter
}

select_disk_wipe() {
    clear_screen
    print_box "${YELLOW}" "Secure Disk Wipe"
    
    print_step "3" "6" "Configure disk wiping options..."
    echo ""
    
    echo -e "${TEXT}Secure wipe uses ${BOLD}shred${NC}${TEXT} to overwrite the disk${NC}"
    echo -e "${TEXT}multiple times (very slow, but secure).${NC}"
    echo ""
    print_box_warning "This can take several hours!"
    echo ""
    
    local response
    echo -e "${BLUE}>>>${NC} ${TEXT}Perform secure wipe? [y/N]:${NC}"
    read -r response
    
    if [[ "$response" =~ ^[yY] ]]; then
        WIPE=true
        echo ""
        print_box_info "Disk will be securely wiped"
    else
        WIPE=false
        echo ""
        print_box_info "Disk will NOT be wiped"
    fi
    
    press_enter
}

set_disk_password() {
    clear_screen
    print_box "${CYAN}" "Disk Encryption Password"
    
    print_step "4" "6" "Configure disk encryption..."
    echo ""
    
    echo -e "${TEXT}Enter a strong password for full disk encryption.${NC}"
    echo -e "${GRAY}This password will be required at every boot.${NC}"
    echo ""
    
    DISKPASS=$(prompt_password "Enter disk encryption password")
    echo ""
    print_box_success "Encryption password set"
    
    press_enter
}

confirm_installation() {
    clear_screen
    print_box "${RED}" "Installation Summary"
    
    print_step "5" "6" "Review your configuration..."
    echo ""
    
    echo -e "${TEXT}Please review the following settings:${NC}"
    echo ""
    
    print_item "Host Configuration" "${CHOSEN_HOST}" "${CYAN}"
    print_item "Target Disk" "${CHOSEN_DRIVE}" "${YELLOW}"
    print_item "Secure Wipe" "$([ "$WIPE" = true ] && echo "Enabled" || echo "Disabled")" "${YELLOW}"
    print_item "Disk Encryption" "Enabled" "${BLUE}"
    print_item "Flake Source" "${FLAKE_REPO}" "${CYAN}"
    
    echo ""
    echo -e "${RED}${BOLD}=================================================${NC}"
    echo -e "${RED}${BOLD}     WARNING: THIS WILL DESTROY ALL DATA!${NC}"
    echo -e "${RED}${BOLD}=================================================${NC}"
    echo ""
    
    local response
    echo -e "${RED}>>>${NC} ${BOLD}${TEXT}Type 'YES' to proceed:${NC}"
    read -r response
    
    if [[ "$response" != "YES" ]]; then
        abort
    fi
    
    echo ""
    print_box_success "Installation confirmed"
    press_enter
}

wipe_disk() {
    if [[ "$WIPE" == true ]]; then
        clear_screen
        print_box "${YELLOW}" "Wiping Disk"
        
        echo -e "${TEXT}Securely wiping ${YELLOW}${BOLD}${CHOSEN_DRIVE}${NC}${TEXT}...${NC}"
        echo -e "${GRAY}This may take several hours.${NC}"
        echo ""
        
        shred -v -n 3 -z "$CHOSEN_DRIVE" 2>&1 | while read -r line; do
            echo -e "${GRAY}${line}${NC}"
        done
        
        echo ""
        print_box_success "Disk wiped successfully"
        sleep 2
    fi
}

install_nixos() {
    clear_screen
    print_box "${GREEN}" "Installing NixOS"
    
    print_step "6" "6" "Beginning installation process..."
    echo ""

    # Generate keys
    echo -e "${BLUE}>>>${NC} ${TEXT}Generating encryption keys...${NC}"
    openssl genrsa -out /tmp/keyfile.key 4096 2>/dev/null
    echo -n "$DISKPASS" > /tmp/secret.key
    print_box_success "Keys generated"
    echo ""

    INSTALLATION_TARGET="$FLAKE_REPO#$CHOSEN_HOST"

    # Run disko
    echo -e "${BLUE}>>>${NC} ${TEXT}Partitioning and formatting disk...${NC}"
    if nix --experimental-features "nix-command flakes" \
        --accept-flake-config \
        run github:nix-community/disko -- \
        --mode disko --flake "$INSTALLATION_TARGET" 2>&1 | \
        while read -r line; do echo -e "${GRAY}  ${line}${NC}"; done; then
        print_box_success "Disk configured"
    else
        print_box_error "Disko failed"
        exit 1
    fi
    echo ""

    # Move secrets
    echo -e "${BLUE}>>>${NC} ${TEXT}Securing encryption keys...${NC}"
    mkdir -p /mnt/root/.secrets
    mv /tmp/secret.key /mnt/root/.secrets/secret.key
    chmod 0400 /mnt/root/.secrets/secret.key
    chown root:root /mnt/root/.secrets/secret.key
    
    mv /tmp/keyfile.key /mnt/root/.secrets/keyfile.key
    chmod 0400 /mnt/root/.secrets/keyfile.key
    chown root:root /mnt/root/.secrets/keyfile.key
    print_box_success "Keys secured"
    echo ""

    # Generate config
    echo -e "${BLUE}>>>${NC} ${TEXT}Generating hardware configuration...${NC}"
    nixos-generate-config --root /mnt 2>&1 | while read -r line; do
        echo -e "${GRAY}  ${line}${NC}"
    done
    print_box_success "Hardware config generated"
    echo ""

    # Install
    echo -e "${BLUE}>>>${NC} ${TEXT}Installing NixOS (this may take a while)...${NC}"
    if nixos-install --no-root-passwd --impure --keep-going --flake "$INSTALLATION_TARGET" 2>&1 | \
        while read -r line; do echo -e "${GRAY}  ${line}${NC}"; done; then
        echo ""
        print_box_success "NixOS installed successfully!"
    else
        echo ""
        print_box_error "Installation had errors"
        exit 1
    fi

    # Clear sensitive variables
    DISKPASS=""
    
    echo ""
    echo -e "${GREEN}${BOLD}=================================================${NC}"
    echo -e "${GREEN}${BOLD}        Installation Complete!${NC}"
    echo -e "${GREEN}${BOLD}=================================================${NC}"
    echo ""
    echo -e "${TEXT}You can now reboot into your new NixOS system.${NC}"
    echo ""
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