#!/usr/bin/env bash
set -euo pipefail

### Catppuccin-inspired Colors (Basic ANSI) ###
CYAN='\033[1;36m'
RED='\033[1;31m'
YELLOW='\033[0;33m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
MAGENTA='\033[0;35m'
TEXT='\033[0;37m'
SUBTEXT='\033[1;37m'
GRAY='\033[0;90m'
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
    local total_width=50
    local title_length=${#title}
    local padding=$((total_width - title_length - 1))
    
    echo -e "${color}╭$(printf '─%.0s' $(seq 1 $total_width))╮${NC}"
    echo -e "${color}│ ${BOLD}${color}${title}${NC}$(printf '%*s' $padding '')${color}│${NC}"
    echo -e "${color}╰$(printf '─%.0s' $(seq 1 $total_width))╯${NC}"
    echo ""
}

print_box_error() {
    local msg=$1
    local prefix="[ERROR] "
    local total_width=50
    local content_length=$((${#prefix} + ${#msg}))
    local padding=$((total_width - content_length - 1))
    
    echo -e "${RED}╭$(printf '─%.0s' $(seq 1 $total_width))╮${NC}"
    echo -e "${RED}│ ${BOLD}${RED}${prefix}${msg}${NC}$(printf '%*s' $padding '')${RED}│${NC}"
    echo -e "${RED}╰$(printf '─%.0s' $(seq 1 $total_width))╯${NC}"
}

print_box_success() {
    local msg=$1
    local prefix="[SUCCESS] "
    local total_width=50
    local content_length=$((${#prefix} + ${#msg}))
    local padding=$((total_width - content_length - 1))
    
    echo -e "${GREEN}╭$(printf '─%.0s' $(seq 1 $total_width))╮${NC}"
    echo -e "${GREEN}│ ${BOLD}${GREEN}${prefix}${msg}${NC}$(printf '%*s' $padding '')${GREEN}│${NC}"
    echo -e "${GREEN}╰$(printf '─%.0s' $(seq 1 $total_width))╯${NC}"
}

print_box_warning() {
    local msg=$1
    local prefix="[WARNING] "
    local total_width=50
    local content_length=$((${#prefix} + ${#msg}))
    local padding=$((total_width - content_length - 1))
    
    echo -e "${YELLOW}╭$(printf '─%.0s' $(seq 1 $total_width))╮${NC}"
    echo -e "${YELLOW}│ ${BOLD}${YELLOW}${prefix}${msg}${NC}$(printf '%*s' $padding '')${YELLOW}│${NC}"
    echo -e "${YELLOW}╰$(printf '─%.0s' $(seq 1 $total_width))╯${NC}"
}

print_box_info() {
    local msg=$1
    local prefix="[INFO] "
    local total_width=50
    local content_length=$((${#prefix} + ${#msg}))
    local padding=$((total_width - content_length - 1))
    
    echo -e "${BLUE}╭$(printf '─%.0s' $(seq 1 $total_width))╮${NC}"
    echo -e "${BLUE}│ ${BOLD}${BLUE}${prefix}${msg}${NC}$(printf '%*s' $padding '')${BLUE}│${NC}"
    echo -e "${BLUE}╰$(printf '─%.0s' $(seq 1 $total_width))╯${NC}"
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

read_password() {
    local prompt=$1
    local password=""
    local char
    
    echo -n "$prompt" >&2
    
    while IFS= read -r -s -n1 char; do
        if [[ $char == $'\0' ]] || [[ -z $char ]]; then
            break
        elif [[ $char == $'\177' ]] || [[ $char == $'\b' ]]; then
            if [ ${#password} -gt 0 ]; then
                password="${password%?}"
                echo -ne "\b \b" >&2
            fi
        else
            password+="$char"
            echo -n "*" >&2
        fi
    done < /dev/tty
    
    echo "" >&2
    echo "$password"
}

prompt_password() {
    local prompt=$1
    local pass1
    local pass2
    
    while true; do
        echo -e "${CYAN}${prompt}${NC}" >&2
        echo "" >&2
        
        pass1=$(read_password "   Password: ")
        echo "" >&2
        
        pass2=$(read_password "   Confirm:  ")
        echo "" >&2
        
        if [[ -z "$pass1" ]]; then
            print_box_error "Password cannot be empty" >&2
            echo "" >&2
        elif [[ "$pass1" != "$pass2" ]]; then
            print_box_error "Passwords do not match" >&2
            echo "" >&2
        else
            echo "$pass1"
            break
        fi
    done
}

require_root() {
    if [[ $(id -u) -ne 0 ]]; then
        print_box_error "Root privileges required"
        exit 1
    fi
}

# ------------------ Host Selection ------------------
get_hosts_from_flake() {
    local tmpfile="/tmp/nix_flake_$$.txt"
    
    nix flake show "$FLAKE_REPO" \
        --extra-experimental-features "nix-command flakes" \
        --accept-flake-config > "$tmpfile" 2>&1
    
    local hosts
    hosts=$(sed 's/\x1b\[[0-9;]*m//g' "$tmpfile" \
        | grep ": NixOS configuration" \
        | sed 's/^[^A-Za-z]*//' \
        | cut -d':' -f1 \
        | sort -u)
    
    rm -f "$tmpfile"
    echo "$hosts"
}

select_host() {
    clear_screen
    print_box "${MAGENTA}" "Select NixOS Host Configuration"
    
    print_step "1" "6" "Fetching available hosts from flake..."
    echo ""
    
    echo -e "${BLUE}>>>${NC} ${TEXT}Connecting to ${CYAN}${FLAKE_REPO}${TEXT}...${NC}"
    echo ""
    
    local hosts_output
    hosts_output=$(get_hosts_from_flake)
    
    if [[ -z "$hosts_output" ]]; then
        echo ""
        print_box_error "No hosts found in the flake"
        echo ""
        exit 1
    fi
    
    declare -a HOSTS=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && HOSTS+=("$line")
    done <<< "$hosts_output"

    if [[ ${#HOSTS[@]} -eq 0 ]]; then
        print_box_error "Failed to parse host list"
        exit 1
    fi

    echo -e "${TEXT}Available configurations:${NC}"
    echo ""
    for i in "${!HOSTS[@]}"; do
        local num=$((i+1))
        echo -e "  ${BLUE}[${BOLD}${num}${NC}${BLUE}]${NC} ${TEXT}${HOSTS[$i]}${NC}"
    done

    echo ""
    local choice
    while true; do
        printf "${BLUE}>>>${NC} ${TEXT}Select host number: ${NC}"
        read -r choice < /dev/tty
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#HOSTS[@]})); then
            CHOSEN_HOST="${HOSTS[$((choice-1))]}"
            echo ""
            print_box_success "Selected: ${CHOSEN_HOST}"
            echo ""
            break
        else
            echo ""
            print_box_error "Invalid choice. Try again"
            echo ""
        fi
    done
}

# ------------------ Disk Selection ------------------
select_disk() {
    clear_screen
    print_box "${MAGENTA}" "Select Installation Disk"
    
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
        printf "${BLUE}>>>${NC} ${TEXT}Select disk number: ${NC}"
        read -r choice < /dev/tty
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#DISKS[@]})); then
            CHOSEN_DRIVE="/dev/${DISKS[$((choice-1))]}"
            echo ""
            print_box_warning "Selected: ${CHOSEN_DRIVE}"
            print_box_warning "ALL DATA WILL BE DESTROYED!"
            echo ""
            break
        else
            echo ""
            print_box_error "Invalid choice. Try again"
            echo ""
        fi
    done
}

select_disk_wipe() {
    clear_screen
    print_box "${MAGENTA}" "Secure Disk Wipe"
    
    print_step "3" "6" "Configure disk wiping options..."
    echo ""
    
    echo -e "${TEXT}Secure wipe uses ${BOLD}shred${NC}${TEXT} to overwrite the disk${NC}"
    echo -e "${TEXT}multiple times (very slow, but secure).${NC}"
    echo ""
    print_box_warning "This can take several hours!"
    echo ""
    
    local response
    printf "${BLUE}>>>${NC} ${TEXT}Perform secure wipe? [y/N]: ${NC}"
    read -r response < /dev/tty
    
    if [[ "$response" =~ ^[yY] ]]; then
        WIPE=true
        echo ""
        print_box_info "Disk will be securely wiped"
        echo ""
    else
        WIPE=false
        echo ""
        print_box_info "Disk will NOT be wiped"
        echo ""
    fi
}

set_disk_password() {
    clear_screen
    print_box "${MAGENTA}" "Disk Encryption Password"
    
    print_step "4" "6" "Configure disk encryption..."
    echo ""
    
    echo -e "${TEXT}Enter a strong password for full disk encryption.${NC}"
    echo -e "${GRAY}This password will be required at every boot.${NC}"
    echo ""
    
    DISKPASS=$(prompt_password "Enter disk encryption password")
    
    print_box_success "Encryption password set"
    echo ""
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
    print_item "Disk Encryption" "Enabled" "${CYAN}"
    print_item "Flake Source" "${FLAKE_REPO}" "${CYAN}"
    
    echo ""
    echo -e "${RED}${BOLD}=================================================${NC}"
    echo -e "${RED}${BOLD}     WARNING: THIS WILL DESTROY ALL DATA!${NC}"
    echo -e "${RED}${BOLD}=================================================${NC}"
    echo ""
    
    local response
    printf "${RED}>>>${NC} ${BOLD}${TEXT}Type 'YES' to proceed: ${NC}"
    read -r response < /dev/tty
    echo ""
    
    if [[ "$response" != "YES" ]]; then
        abort
    fi
    
    print_box_success "Installation confirmed"
    echo ""
}

wipe_disk() {
    if [[ "$WIPE" == true ]]; then
        clear_screen
        print_box "${MAGENTA}" "Wiping Disk"
        
        echo -e "${TEXT}Securely wiping ${YELLOW}${BOLD}${CHOSEN_DRIVE}${NC}${TEXT}...${NC}"
        echo -e "${GRAY}This may take several hours.${NC}"
        echo ""
        
        shred -v -n 3 -z "$CHOSEN_DRIVE"
        
        echo ""
        print_box_success "Disk wiped successfully"
        echo ""
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
    echo ""
    openssl genrsa -out /tmp/keyfile.key 4096
    echo -n "$DISKPASS" > /tmp/secret.key
    echo ""
    print_box_success "Keys generated"
    echo ""

    INSTALLATION_TARGET="$FLAKE_REPO#$CHOSEN_HOST"

    # Run disko
    echo -e "${BLUE}>>>${NC} ${TEXT}Partitioning and formatting disk...${NC}"
    echo ""
    nix --experimental-features "nix-command flakes" \
        --accept-flake-config \
        run github:nix-community/disko -- \
        --mode disko --flake "$INSTALLATION_TARGET"
    
    echo ""
    print_box_success "Disk configured"
    echo ""

    # Move secrets
    echo -e "${BLUE}>>>${NC} ${TEXT}Securing encryption keys...${NC}"
    echo ""
    mkdir -p /mnt/root/.secrets
    mv -v /tmp/secret.key /mnt/root/.secrets/secret.key
    chmod -v 0400 /mnt/root/.secrets/secret.key
    chown -v root:root /mnt/root/.secrets/secret.key
    
    mv -v /tmp/keyfile.key /mnt/root/.secrets/keyfile.key
    chmod -v 0400 /mnt/root/.secrets/keyfile.key
    chown -v root:root /mnt/root/.secrets/keyfile.key
    echo ""
    print_box_success "Keys secured"
    echo ""

    # Generate config
    echo -e "${BLUE}>>>${NC} ${TEXT}Generating hardware configuration...${NC}"
    echo ""
    nixos-generate-config --root /mnt
    echo ""
    print_box_success "Hardware config generated"
    echo ""

    # Install
    echo -e "${BLUE}>>>${NC} ${TEXT}Installing NixOS (this may take a while)...${NC}"
    echo ""
    nixos-install --no-root-passwd --impure --keep-going --flake "$INSTALLATION_TARGET"
    
    echo ""
    print_box_success "NixOS installed successfully!"

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