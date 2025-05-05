#!/bin/bash

VM_KALI_NAME="Kali_Attacker_PwnKit"
VM_VULN_NAME="Ubuntu_Vulnerable_PwnKit"
VM_OS_TYPE="Linux_64"

VDI_KALI_PATH="vbox_disks/kali.vdi"
VDI_VULN_PATH="vbox_disks/ubuntu.vdi"
VM_RAM="2048"
VM_VRAM="128"
VM_CPUS="2"

NETWORK_NAME="vboxnet0"

echo "Starting VM Environment (CVE-2021-4034)"

create_vm() {
    local vm_name="$1"
    local vdi_path="$2"
    local os_type="$3"

    if [ ! -f "$vdi_path" ]; then
        echo "Error: VDI file not found at $vdi_path"
        exit 1
    fi

    if VBoxManage showvminfo "$vm_name" > /dev/null 2>&1; then
        echo "VM '$vm_name' already exists. Unregistering and deleting files..."
        VBoxManage controlvm "$vm_name" poweroff --type emergencysave > /dev/null 2>&1 || true # Forceer stop
        VBoxManage unregistervm "$vm_name" --delete > /dev/null 2>&1 || true # Verwijder registratie en bestanden
        sleep 2 # Geef VBox even tijd
    fi

    VBoxManage createvm --name "$vm_name" --ostype "$os_type" --register

    VBoxManage modifyvm "$vm_name" --memory "$VM_RAM" --cpus "$VM_CPUS" --vram "$VM_VRAM"
    VBoxManage modifyvm "$vm_name" --graphicscontroller vmsvga # Aanbevolen voor moderne Linux
    VBoxManage modifyvm "$vm_name" --audio none # Audio is meestal niet nodig
    VBoxManage modifyvm "$vm_name" --clipboard-mode bidirectional # Handig voor copy/paste

    VBoxManage modifyvm "$vm_name" --nic1 hostonly --hostonlyadapter1 "$NETWORK_NAME"

    VBoxManage storagectl "$vm_name" --name "SATA Controller" --add sata --controller IntelAhci --portcount 1 --bootable on
    VBoxManage storageattach "$vm_name" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$vdi_path"

    VBoxManage startvm "$vm_name" --type gui # Start met GUI (of headless)
}

create_vm "$VM_KALI_NAME" "$VDI_KALI_PATH" "Debian_64" # Kali is gebaseerd op Debian
create_vm "$VM_VULN_NAME" "$VDI_VULN_PATH" "Ubuntu_64" # Voor Ubuntu

echo "--- Environment Setup Script Finished ---"
echo "2. Log in to '$VM_VULN_NAME' (Credentials usually: osboxes.org / osboxes.org)."
echo "3. Open a terminal in '$VM_VULN_NAME'."
echo "4. Run the verification script: ./scripts/configure_vulnerable_vm/verify_polkit.sh (copy it first or type commands)."
echo "5. Set up a user for exploitation on '$VM_VULN_NAME' (e.g., 'tester')."
echo "6. Log in to '$VM_KALI_NAME'."
exit 0
