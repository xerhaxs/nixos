#!/usr/bin/env bash
set -euo pipefail

### Catppuccin Mocha Colors (256-color mode) ###
MAUVE='\033[38;5;183m'      # Mauve
RED='\033[38;5;204m'        # Red
MAROON='\033[38;5;174m'     # Maroon
PEACH='\033[38;5;216m'      # Peach
YELLOW='\033[38;5;222m'     # Yellow
GREEN='\033[38;5;151m'      # Green
TEAL='\033[38;5;122m'       # Teal
SKY='\033[38;5;117m'        # Sky
SAPPHIRE='\033[38;5;111m'   # Sapphire
BLUE='\033[38;5;117m'       # Blue
LAVENDER='\033[38;5;147m'   # Lavender
TEXT='\033[38;5;254m'       # Text
SUBTEXT1='\033[38;5;250m'   # Subtext1
SUBTEXT0='\033[38;5;245m'   # Subtext0
OVERLAY2='\033[38;5;240m'   # Overlay2
OVERLAY1='\033[38;5;238m'   # Overlay1
OVERLAY0='\033[38;5;236m'   # Overlay0
SURFACE2='\033[38;5;235m'   # Surface2
SURFACE1='\033[38;5;234m'   # Surface1
SURFACE0='\033[38;5;233m'   # Surface0
BASE='\033[38;5;232m'       # Base
MANTLE='\033[38;5;233m'     # Mantle
CRUST='\033[38;5;232m'      # Crust
NC='\033[0m'
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
    echo -e "${MAUVE}${BOLD}"
    cat << 'EOF'
    ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗
    ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝
    ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗
    ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║
    ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║
    ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
EOF
    echo -e "${LAVENDER}     I N S T A L L E R   S C R I P T"
    echo -e "${NC}"
    echo -e "${SUBTEXT0}=================================================${NC}\n"
}

print_box() {
    local color=$1
    local title=$2
    local width=48
    
    echo -e "${color}╭$(printf '─%.0s' $(seq 1 $width))╮${NC}"
    echo -e "${color}│${NC} ${BOLD}${TEXT}${title}${NC}"
    echo -e "${color}╰$(printf '─%.0s' $(seq 1 $width))╯${NC}"
    echo ""
}

print_box_error() {
    local msg=$1
    echo -e "${RED}╭──────────────────────────────────────────────────╮${NC}"
    echo -e "${RED}│${NC} [ERROR] ${BOLD}${RED}${msg}${NC}"
    echo -e "${RED}╰──────────────────────────────────────────────────╯${NC}"
}

print_box_success() {
    local msg=$1
    echo -e "${GREEN}╭──────────────────────────────────────────────────╮${NC}"
    echo -e "${GREEN}│${NC} [SUCCESS] ${BOLD}${GREEN}${msg}${NC}"
    echo -e "${GREEN}╰──────────────────────────────────────────────────╯${NC}"
}

print_box_warning() {
    local msg=$1
    echo -e "${YELLOW}╭──────────────────────────────────────────────────╮${NC}"
    echo -e "${YELLOW}│${NC} [WARNING] ${BOLD}${YELLOW}${msg}${NC}"
    echo -e "${YELLOW}╰──────────────────────────────────────────────────╯${NC}"
}

print_box_info() {
    local msg=$1
    echo -e "${BLUE}╭──────────────────────────────────────────────────╮${NC}"
    echo -e "${BLUE}│${NC} [INFO] ${BOLD}${BLUE}${msg}${NC}"
    echo -e "${BLUE}╰──────────────────────────────────────────────────╯${NC}"
}

print_step() {
    local step=$1
    local total=$2
    local desc=$3
    echo -e "${MAUVE}[${LAVENDER}${step}${MAUVE}/${LAVENDER}${total}${MAUVE}]${NC} ${TEXT}${desc}${NC}"
}

print_item() {
    local label=$1
    local value=$2
    local color=$3
    echo -e "  ${SUBTEXT1}${label}:${NC} ${color}${BOLD}${value}${NC}"
}

prompt_password() {
    local prompt=$1
    while true; do
        echo -e "${LAVENDER}${prompt}${NC}"
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
    echo -e "${DIM}${SUBTEXT0}Press Enter to continue...${NC}"
    read -r
}

# ------------------ Host Selection ------------------
get_hosts_from_flake() {
    local hosts=""
    
    # Method 1: Parse flake show output (most reliable)
    hosts=$(nix --extra-experimental-features "nix-command flakes" \
        --accept-flake-config \
        flake show "$FLAKE_REPO" 2>&1 \
        | grep -A 50 "nixosConfigurations" \
        | grep "├───\|└───" \
        | sed 's/.*[├└]───//' \
        | awk '{print $1}' \
        | grep -v "^$" || true)
    
    # Method 2: Direct evaluation as fallback
    if [[ -z "$hosts" ]]; then
        hosts=$(nix --extra-experimental-features "nix-command flakes" \
            --accept-flake-config \
            eval --impure --expr \
            "builtins.attrNames (builtins.getFlake \"$FLAKE_REPO\").nixosConfigurations" \
            2>/dev/null | tr -d '[]" ' | tr ';' '\n' | grep -v '^$' || true)
    fi
    
    echo "$hosts"
}

select_host() {
    clear_screen
    print_box "${MAUVE}" "Select NixOS Host Configuration"
    
    print_step "1" "6" "Fetching available hosts from flake..."
    echo ""
    
    echo -e "${BLUE}>>>${NC} ${TEXT}Connecting to ${FLAKE_REPO}...${NC}"
    echo ""
    
    local hosts_output
    hosts_output=$(get_hosts_from_flake)
    
    if [[ -z "$hosts_output" ]]; then
        echo ""
        print_box_error "No hosts found in the flake"
        echo ""
        echo -e "${SUBTEXT0}Troubleshooting tips:${NC}"
        echo -e "${SUBTEXT0}  - Check your internet connection${NC}"
        echo -e "${SUBTEXT0}  - Verify the flake URL: ${FLAKE_REPO}${NC}"
        echo -e "${SUBTEXT0}  - Run manually: nix flake show ${FLAKE_REPO}${NC}"
        exit 1
    fi
    
    # Read hosts into array properly
    local -a HOSTS
    while IFS= read -r line; do
        [[ -n "$line" ]] && HOSTS+=("$line")
    done <<< "$hosts_output"

    echo -e "${TEXT}Available configurations:${NC}\n"
    for i in "${!HOSTS[@]}"; do
        local num=$((i+1))
        printf "  ${LAVENDER}[${BOLD}%d${NC}${LAVENDER}]${NC} ${TEXT}%s${NC}\n" "$num" "${HOSTS[$i]}"
    done

    echo ""
    while true; do
        echo -ne "${BLUE}>>>${NC} ${TEXT}Select host number: ${NC}"
        read -r choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#HOSTS[@]})); then
            CHOSEN_HOST="${HOSTS[$((choice-1))]}"
            echo ""
            print_box_success "Selected: ${CHOSEN_HOST}"
            break
        else
            print_box_error "Invalid choice. Please try again"
        fi
    done
    
    press_enter
}

# ------------------ Disk Selection ------------------
select_disk() {
    clear_screen
    print_box "${PEACH}" "Select Installation Disk"
    
    print_step "2" "6" "Scanning available disks..."
    echo ""
    
    mapfile -t DISKS < <(lsblk -dn -o NAME,TYPE | awk '$2=="disk"{print $1}')
    
    if [[ ${#DISKS[@]} -eq 0 ]]; then
        print_box_error "No disks found"
        exit 1
    fi

    echo -e "${TEXT}Available disks:${NC}\n"
    for i in "${!DISKS[@]}"; do
        local num=$((i+1))
        local disk="${DISKS[$i]}"
        local size=$(lsblk -dn -o SIZE "/dev/${disk}")
        local model=$(lsblk -dn -o MODEL "/dev/${disk}" 2>/dev/null | xargs || echo "Unknown")
        
        printf "  ${LAVENDER}[${BOLD}%d${NC}${LAVENDER}]${NC} ${PEACH}/dev/%s${NC}\n" "$num" "$disk"
        echo -e "      ${SUBTEXT0}Size: ${size}${NC}"
        echo -e "      ${SUBTEXT0}Model: ${model}${NC}"
        echo ""
    done

    while true; do
        echo -ne "${BLUE}>>>${NC} ${TEXT}Select disk number: ${NC}"
        read -r choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#DISKS[@]})); then
            CHOSEN_DRIVE="/dev/${DISKS[$((choice-1))]}"
            echo ""
            print_box_warning "Selected: ${CHOSEN_DRIVE}"
            print_box_warning "ALL DATA ON THIS DISK WILL BE DESTROYED!"
            break
        else
            print_box_error "Invalid choice. Please try again"
        fi
    done
    
    press_enter
}

select_disk_wipe() {
    clear_screen
    print_box "${YELLOW}" "Secure Disk Wipe"
    
    print_step "3" "6" "Configure disk wiping options..."
    echo ""
    
    echo -e "${TEXT}Secure disk wipe uses ${BOLD}shred${NC}${TEXT} to overwrite the disk"
    echo -e "multiple times, making data recovery nearly impossible.${NC}"
    echo ""
    print_box_warning "This process can take several hours!"
    echo ""
    
    echo -ne "${BLUE}>>>${NC} ${TEXT}Perform secure wipe? [y/N]: ${NC}"
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
    print_box "${LAVENDER}" "Disk Encryption Password"
    
    print_step "4" "6" "Configure disk encryption..."
    echo ""
    
    echo -e "${TEXT}Enter a strong password for full disk encryption.${NC}"
    echo -e "${SUBTEXT0}This password will be required at every boot.${NC}"
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
    
    echo -e "${TEXT}Please review the following settings:${NC}\n"
    
    print_item "Host Configuration" "${CHOSEN_HOST}" "${MAUVE}"
    print_item "Target Disk" "${CHOSEN_DRIVE}" "${PEACH}"
    print_item "Secure Wipe" "$([ "$WIPE" = true ] && echo "Enabled" || echo "Disabled")" "${YELLOW}"
    print_item "Disk Encryption" "Enabled" "${LAVENDER}"
    print_item "Flake Source" "${FLAKE_REPO}" "${BLUE}"
    
    echo ""
    echo -e "${RED}${BOLD}=================================================${NC}"
    echo -e "${RED}${BOLD}     WARNING: THIS WILL DESTROY ALL DATA!${NC}"
    echo -e "${RED}${BOLD}=================================================${NC}"
    echo ""
    
    echo -ne "${RED}>>>${NC} ${BOLD}${TEXT}Type 'YES' to proceed: ${NC}"
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
        
        echo -e "${TEXT}Securely wiping ${PEACH}${BOLD}${CHOSEN_DRIVE}${NC}${TEXT}...${NC}"
        echo -e "${SUBTEXT0}This may take several hours.${NC}\n"
        
        shred -v -n 3 -z "$CHOSEN_DRIVE" 2>&1 | while read -r line; do
            echo -e "${SUBTEXT0}${line}${NC}"
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
        while read -r line; do echo -e "${SUBTEXT0}  ${line}${NC}"; done; then
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
        echo -e "${SUBTEXT0}  ${line}${NC}"
    done
    print_box_success "Hardware config generated"
    echo ""

    # Install
    echo -e "${BLUE}>>>${NC} ${TEXT}Installing NixOS (this may take a while)...${NC}"
    if nixos-install --no-root-passwd --impure --keep-going --flake "$INSTALLATION_TARGET" 2>&1 | \
        while read -r line; do echo -e "${SUBTEXT0}  ${line}${NC}"; done; then
        echo ""
        print_box_success "NixOS installed successfully!"
    else
        echo ""
        print_box_error "Installation completed with errors"
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