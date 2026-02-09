#!/usr/bin/env bash
set -euo pipefail

# Arch Linux System Update Script
# Features: pacman update, paru update, system cleanup, and error handling

# Configuration
LOG_FILE="${HOME}/.tmp/arch_update.log"
TMP_DIR="${HOME}/.tmp"

# Create log directory if it doesn't exist
mkdir -p "${TMP_DIR}"

# Function to log messages with timestamp
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

# Function to show error messages
error() {
    echo "[ERROR] $1" | tee -a "${LOG_FILE}"
}

# Function to show success messages
success() {
    echo "[✓] $1" | tee -a "${LOG_FILE}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to update pacman packages
update_pacman() {
    log "Updating pacman package databases..."
    if sudo pacman -Sy --noconfirm; then
        log "Checking for system updates..."
        if sudo pacman -Qu | grep -q .; then
            log "System updates available. Updating..."
            sudo pacman -Su --noconfirm
            success "Pacman packages updated successfully"
        else
            success "System is already up to date"
        fi
    else
        error "Failed to update pacman packages"
        return 1
    fi
}

# Function to update paru (AUR) packages
update_paru() {
    if command_exists paru; then
        log "Updating AUR packages with paru..."
        if paru -Syu --devel --noconfirm; then
            success "AUR packages updated successfully"
        else
            error "Failed to update AUR packages"
            return 1
        fi
    else
        log "Paru not installed. Skipping AUR updates."
    fi
}

# Function to clean package cache
clean_cache() {
    log "Cleaning package cache..."
    sudo pacman -Sc --noconfirm
    success "Package cache cleaned"
}

# Function to remove orphaned packages
remove_orphans() {
    log "Checking for orphaned packages..."
    orphans=$(pacman -Qdtq)
    if [[ -n "$orphans" ]]; then
        log "Found orphaned packages: $orphans"
        read -p "Remove orphaned packages? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo pacman -Rns $(pacman -Qdtq) --noconfirm
            success "Orphaned packages removed"
        else
            log "Skipped removing orphaned packages"
        fi
    else
        success "No orphaned packages found"
    fi
}

# Function to check for news
check_news() {
    log "Checking Arch Linux news..."
    if command_exists archnews; then
        archnews
    else
        log "archnews not installed. Consider installing it for system news."
    fi
}

# Main execution
main() {
    echo -e "\n🚀 Arch Linux System Update\n"
    echo "Log file: ${LOG_FILE}"
    echo "Starting at: $(date +'%Y-%m-%d %H:%M:%S')"
    echo "========================================"
    
    # Update pacman packages
    update_pacman
    
    # Update AUR packages
    update_paru
    
    # Clean package cache
    clean_cache
    
    # Remove orphaned packages
    remove_orphans
    
    # Check for news
    check_news
    
    echo -e "\n[✅] Arch Linux update completed!"
    echo "Finished at: $(date +'%Y-%m-%d %H:%M:%S')"
    echo "Log file available at: ${LOG_FILE}"
}

# Run main function
main
