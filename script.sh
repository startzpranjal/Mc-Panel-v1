#!/bin/bash

# ==============================================================================
# Script Name: Mc-Panel-v1 Installer
# Description: Installs dependencies, clones Mc-Panel-v1, and starts the node app.
# ==============================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# --- Color Definitions ---
B_RED='\033[1;31m'   # Bold Red
B_BLUE='\033[1;34m'  # Bold Blue
B_WHITE='\033[1;37m' # Bold White
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'         # No Color / Reset

# --- Helper Functions ---
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${B_RED}[ERROR]${NC} $1"
}

# --- Step 1: Root Privilege Check ---
if [ "$EUID" -ne 0 ]; then
    log_error "Please run this script as root or using sudo."
    exit 1
fi

# --- Step 2: Branding Banner ---
clear
echo -e "${B_RED}-------------------------------------------------------------------------${NC}"
echo -e "${B_RED}"
cat << "EOF"
 ███████  ████████   █████   ████████  ████████ ████████ 
░██_  __█░__░██__/  ██_  ██ ░██_  __█ ░__░██__/░___  ██_/ 
░███████    ░██    ██_  ███ ░███████     ░██      ████/   
░_____░██   ░██   █████████ ░██__  ██    ░██     ████/    
 ███████    ░██  ██_  __░██ ░██  ░░██    ░██    █████████ 
░_______/   ░__/░__/   ░__/ ░__/   ░__/  ░__/   ░________/
EOF
echo -e "${NC}"
echo -e "${B_RED}-------------------------------------------------------------------------${NC}"
echo -e "${B_BLUE}                             MC PANEL V1                                 ${NC}"
echo -e "${B_RED}-------------------------------------------------------------------------${NC}"
echo ""

# --- Step 3: Package System Update ---
log_info "Updating package lists..."
apt-get update -y

# --- Step 4: Core Dependency Installations ---
log_info "Installing core system tools (unzip, curl, git)..."
apt-get install unzip curl git -y

log_info "Installing OpenJDK 21 Java Runtime Environment..."
apt-get install openjdk-21-jdk -y

# --- Step 5: Application Repository Cloning & Unzipping ---
log_info "Cloning the repository from GitHub..."
if [ -d "Mc-Panel-v1" ]; then
    log_warn "Directory 'Mc-Panel-v1' already exists. Removing older instance..."
    rm -rf Mc-Panel-v1
fi
git clone https://github.com

log_info "Navigating into directory and unpacking content..."
cd Mc-Panel-v1
if [ -f "panel.zip" ]; then
    unzip -o panel.zip
else
    log_error "panel.zip not found in the cloned repository!"
    exit 1
fi

# --- Step 6: Node.js Framework Environment Setup ---
log_info "Configuring Node.js version 20.x repository source..."
curl -fsSL https://nodesource.com | bash -

log_info "Installing Node.js packages..."
apt-get install nodejs -y

# --- Step 7: NPM Packages Installation & Launch ---
log_info "Installing Node project dependencies..."
npm i

log_info "Launching MC PANEL V1 application..."
node .
