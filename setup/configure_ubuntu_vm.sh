#!/bin/bash

# =============================================================================
# Ubuntu VM Configuratie Script
# =============================================================================

# Kleuren voor output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functies
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WAARSCHUWING]${NC} $1"
}

log_error() {
    echo -e "${RED}[FOUT]${NC} $1"
}

# Controleer of script als root draait
if [ "$EUID" -ne 0 ]; then
    log_error "Dit script moet als root worden uitgevoerd"
    exit 1
fi

# =============================================================================
# Hoofdscript
# =============================================================================

echo "Start Ubuntu VM Configuratie"
echo "===================================================="

# Update systeem
log_info "Systeem updaten..."
apt update && apt upgrade -y

# Installeer SSH server
log_info "SSH server installeren..."
apt install -y openssh-server

# Maak tester gebruiker aan
log_info "Tester gebruiker aanmaken..."
useradd -m tester
echo 'tester:testerpwd' | chpasswd
usermod -aG sudo tester

# Configureer SSH
log_info "SSH configureren..."
systemctl enable --now ssh
ufw allow 22/tcp

# Toon IP adres
log_info "Netwerk configuratie:"
ip -4 addr show scope global | grep -oP 'inet \K[\d.]+'

echo "===================================================="
echo "Configuratie succesvol voltooid!"
echo ""
echo "Je kunt nu inloggen met:"
echo "  Gebruikersnaam: tester"
echo "  Wachtwoord: testerpwd"
echo "===================================================="

exit 0
