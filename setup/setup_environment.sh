#!/bin/bash

# =============================================================================
# CVE-2021-4034 (PwnKit) Lab Omgeving Setup Script
# =============================================================================

# Configuratie
VM_KALI_NAME="Kali_Attacker_PwnKit"
VM_VULN_NAME="Ubuntu_Vulnerable_PwnKit"
VM_OS_TYPE="Linux_64"
VM_RAM="2048"
VM_VRAM="128"
VM_CPUS="2"
NETWORK_NAME="vboxnet0"

# Paden
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VDI_KALI_PATH="${SCRIPT_DIR}/vbox_disks/kali.vdi"
VDI_VULN_PATH="${SCRIPT_DIR}/vbox_disks/ubuntu.vdi"

# Kleuren voor output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# =============================================================================
# Helper Functies
# =============================================================================

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WAARSCHUWING]${NC} $1"
}

log_error() {
    echo -e "${RED}[FOUT]${NC} $1"
}

check_prerequisites() {
    log_info "Controleren van vereisten..."
    
    # Controleer VirtualBox installatie
    if ! command -v VBoxManage &> /dev/null; then
        log_error "VirtualBox is niet geïnstalleerd. Installeer VirtualBox 6.1 of hoger."
        exit 1
    fi
    
    # Controleer VDI bestanden
    if [ ! -f "$VDI_KALI_PATH" ]; then
        log_error "Kali VDI bestand niet gevonden op $VDI_KALI_PATH"
        exit 1
    fi
    
    if [ ! -f "$VDI_VULN_PATH" ]; then
        log_error "Ubuntu VDI bestand niet gevonden op $VDI_VULN_PATH"
        exit 1
    fi
    
    log_info "Alle vereisten zijn voldaan."
}

create_hostonly_network() {
    log_info "Aanmaken van host-only netwerk..."
    
    if ! VBoxManage list hostonlyifs | grep -q "$NETWORK_NAME"; then
        VBoxManage hostonlyif create
        log_info "Host-only netwerk aangemaakt: $NETWORK_NAME"
    else
        log_info "Host-only netwerk $NETWORK_NAME bestaat al."
    fi
}

cleanup_vm() {
    local vm_name="$1"
    
    if VBoxManage showvminfo "$vm_name" > /dev/null 2>&1; then
        log_info "Opruimen van bestaande VM: $vm_name"
        VBoxManage controlvm "$vm_name" poweroff --type emergencysave > /dev/null 2>&1 || true
        VBoxManage unregistervm "$vm_name" --delete > /dev/null 2>&1 || true
        sleep 2
    fi
}

create_vm() {
    local vm_name="$1"
    local vdi_path="$2"
    local os_type="$3"
    
    log_info "Aanmaken van VM: $vm_name"
    
    # Opruimen van bestaande VM indien aanwezig
    cleanup_vm "$vm_name"
    
    # Nieuwe VM aanmaken
    VBoxManage createvm --name "$vm_name" --ostype "$os_type" --register
    
    # VM instellingen configureren
    VBoxManage modifyvm "$vm_name" \
        --memory "$VM_RAM" \
        --cpus "$VM_CPUS" \
        --vram "$VM_VRAM" \
        --graphicscontroller vmsvga \
        --audio none \
        --clipboard-mode bidirectional \
        --nic1 hostonly \
        --hostonlyadapter1 "$NETWORK_NAME" \
        --nicpromisc1 allow-all
    
    # Opslag configureren
    VBoxManage storagectl "$vm_name" \
        --name "SATA Controller" \
        --add sata \
        --controller IntelAhci \
        --portcount 1 \
        --bootable on
    
    VBoxManage storageattach "$vm_name" \
        --storagectl "SATA Controller" \
        --port 0 \
        --device 0 \
        --type hdd \
        --medium "$vdi_path"
    
    log_info "VM $vm_name succesvol aangemaakt."
}

# =============================================================================
# Hoofdscript
# =============================================================================

echo "Start CVE-2021-4034 (PwnKit) Lab Omgeving Setup"
echo "===================================================="

# Controleer vereisten
check_prerequisites

# Maak host-only netwerk aan
create_hostonly_network

# Maak VM's aan
create_vm "$VM_KALI_NAME" "$VDI_KALI_PATH" "Debian_64"
create_vm "$VM_VULN_NAME" "$VDI_VULN_PATH" "Ubuntu_64"

# Start VM's
log_info "Starten van VM's..."
VBoxManage startvm "$VM_KALI_NAME" --type gui
VBoxManage startvm "$VM_VULN_NAME" --type gui

echo "===================================================="
echo "Setup succesvol voltooid!"
echo ""
echo "Volgende stappen:"
echo "1. Log in op $VM_VULN_NAME (Inloggegevens: osboxes/osboxes.org)"
echo "2. Maak SSH gebruiker aan:"
echo "   sudo useradd -m tester"
echo "   echo 'tester:testerpwd' | sudo chpasswd"
echo "   sudo usermod -aG sudo tester"
echo "3. Configureer SSH:"
echo "   sudo apt update"
echo "   sudo apt install -y openssh-server"
echo "   sudo systemctl enable --now ssh"
echo "   sudo ufw allow 22/tcp"
echo "4. Log in op $VM_KALI_NAME (Inloggegevens: osboxes/osboxes)"
echo "5. Ga verder naar de exploit gids in docs/exploitguide.md"
echo "===================================================="

exit 0
