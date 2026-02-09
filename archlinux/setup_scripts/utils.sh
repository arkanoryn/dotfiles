#!/usr/bin/env bash

# Shared utilities for Arch Linux setup scripts

# Configuration
UTILS_TMP_PATH="${HOME}/.tmp"
UTILS_LOGFILE_PATH="${UTILS_TMP_PATH}/setup.log"

# Non-interactive mode (set NON_INTERACTIVE=1 to skip all prompts)
NON_INTERACTIVE="${NON_INTERACTIVE:-0}"

# Create temporary directory if it doesn't exist
mkdir -p "${UTILS_TMP_PATH}"

# Function to show progress with dots
show_progress() {
    local message="$1"
    local pid="$2"
    local dots=""

    # Show initial message
    echo -ne "\r\033[K[⏳] $message"

    # Add dots every 2 seconds while process is running
    while kill -0 "$pid" 2>/dev/null; do
        dots="${dots}."
        echo -ne "\r\033[K[⏳] $message$dots"
        sleep 2
    done

    # Wait for process to finish and get exit code
    wait "$pid"
    local exit_code=$?

    if [ $exit_code -eq 0 ]; then
        echo -e "\r\033[K[✓] $message"
    else
        echo -e "\r\033[K[❌] $message"
    fi

    return $exit_code
}

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>"${UTILS_LOGFILE_PATH}"
}

# Function to mark completion (simple version)
mark_done() {
    echo -e "\r\033[K[✓] $1"
}

# Function to show error
error() {
    echo -e "\r\033[K[❌] $1"
    log "ERROR: $1"
}

# Function to install with progress
install_with_progress() {
    local message="$1"
    shift
    log "$message"
    echo -e "\n$message"
    ("$@" >>"${UTILS_LOGFILE_PATH}" 2>&1) & show_progress "$message" $!
}

# Function to ask yes/no question and install if yes
ask_and_install() {
    local message="$1"
    shift
    
    # Non-interactive mode: always install
    if [[ "$NON_INTERACTIVE" -eq 1 ]]; then
        log "Non-interactive mode: Auto-installing $message"
        install_with_progress "$message" "$@"
        return
    fi
    
    # Interactive mode: ask for confirmation
    read -p "$message " -n 1 -r
    echo # move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_with_progress "$message" "$@"
    else
        log "Skipped: $message"
    fi
}

# Function to ask multiple choice question
ask_multiple_choice() {
    local question="$1"
    shift
    local options=("$@")
    local choice
    
    # Non-interactive mode: select first option (default)
    if [[ "$NON_INTERACTIVE" -eq 1 ]]; then
        echo "Non-interactive mode: Auto-selecting first option: ${options[0]}"
        log "Non-interactive mode: Selected: ${options[0]}"
        return 1
    fi
    
    # Interactive mode: show menu and ask for choice
    echo -e "\n$question"
    for i in "${!options[@]}"; do
        echo "$((i+1)). ${options[i]}"
    done
    
    while true; do
        read -p "Enter your choice (1-${#options[@]}): " choice
        if [[ $choice -ge 1 && $choice -le ${#options[@]} ]]; then
            echo "Selected: ${options[$((choice-1))]}"
            log "Selected: ${options[$((choice-1))]}"
            return $choice
        else
            echo "Invalid choice. Please try again."
        fi
    done
}

