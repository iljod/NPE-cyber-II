# =============================================================================
# CVE-2021-4034 (PwnKit) Lab Environment Setup Script - PowerShell Version
# =============================================================================

# Configuration
$VM_KALI_NAME = "Kali_Attacker_PwnKit"
$VM_VULN_NAME = "Ubuntu_Vulnerable_PwnKit"
# $VM_OS_TYPE = "Linux_64"  # Removed as it was unused
$VM_RAM = 2048
$VM_VRAM = 128
$VM_CPUS = 2
$NAT_NETWORK_NAME = "PwnKitNatNetwork" # Added for NAT Network
$NAT_NETWORK_CIDR = "10.0.5.0/24"   # Added for NAT Network

# Paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$VDI_KALI_PATH = Join-Path $ScriptDir "vbox_disks\kali.vdi"
$VDI_VULN_PATH = Join-Path $ScriptDir "vbox_disks\ubuntu.vdi"

# Helper functions
function Write-Info { Write-Host "[INFO] $args" -ForegroundColor Green }
function Write-WarningCustom { Write-Host "[WAARSCHUWING] $args" -ForegroundColor Yellow }
function Write-ErrorCustom { Write-Host "[FOUT] $args" -ForegroundColor Red }

function Test-Prerequisites {
    Write-Info "Controleren van vereisten..."

    if (-not (Get-Command VBoxManage.exe -ErrorAction SilentlyContinue)) {
        Write-ErrorCustom "VirtualBox is niet geïnstalleerd of VBoxManage is niet in PATH."
        exit 1
    }

    if (-not (Test-Path $VDI_KALI_PATH)) {
        Write-ErrorCustom "Kali VDI bestand niet gevonden op $VDI_KALI_PATH"
        exit 1
    }

    if (-not (Test-Path $VDI_VULN_PATH)) {
        Write-ErrorCustom "Ubuntu VDI bestand niet gevonden op $VDI_VULN_PATH"
        exit 1
    }

    Write-Info "Alle vereisten zijn voldaan."
}

function New-NatNetwork {
    Write-Info "Controleren/Aanmaken van NAT-netwerk: $NAT_NETWORK_NAME..."
    $natNetworkExists = VBoxManage list natnetworks | Select-String -Quiet $NAT_NETWORK_NAME
    if (-not $natNetworkExists) {
        Write-Info "NAT-netwerk $NAT_NETWORK_NAME niet gevonden, bezig met aanmaken..."
        try {
            VBoxManage natnetwork add --netname $NAT_NETWORK_NAME --network $NAT_NETWORK_CIDR --enable --dhcp on 2>&1 | Out-Null
            Write-Info "NAT-netwerk $NAT_NETWORK_NAME succesvol aangemaakt met CIDR $NAT_NETWORK_CIDR en DHCP ingeschakeld."
        } catch {
            Write-ErrorCustom "Kon NAT-netwerk $NAT_NETWORK_NAME niet aanmaken. Fout: $($_.Exception.Message)"
            exit 1
        }
    } else {
        Write-Info "NAT-netwerk $NAT_NETWORK_NAME bestaat al."
    }
}

function Remove-VMIfExists($vmName) {
    $exists = VBoxManage list vms | Select-String $vmName

    if ($exists) {
        Write-Info "Opruimen van bestaande VM: $vmName"
        VBoxManage controlvm $vmName poweroff 2>$null
        VBoxManage unregistervm $vmName --delete 2>$null
        Start-Sleep -Seconds 2
    }
}

function New-VM($vmName, $vdiPath, $osType) {
    Write-Info "Aanmaken van VM: $vmName"

    Remove-VMIfExists $vmName

    VBoxManage createvm --name $vmName --ostype $osType --register

    VBoxManage modifyvm $vmName `
        --memory $VM_RAM `
        --cpus $VM_CPUS `
        --vram $VM_VRAM `
        --graphicscontroller vmsvga `
        --audio none `
        --clipboard-mode bidirectional `
        --nic1 natnetwork `
        --nat-network1 $NAT_NETWORK_NAME

    VBoxManage storagectl $vmName `
        --name "SATA Controller" `
        --add sata `
        --controller IntelAhci `
        --portcount 1 `
        --bootable on

    VBoxManage storageattach $vmName `
        --storagectl "SATA Controller" `
        --port 0 `
        --device 0 `
        --type hdd `
        --medium $vdiPath

    Write-Info "VM $vmName succesvol aangemaakt."
}

# =============================================================================
# Main Script
# =============================================================================

Write-Host "Start CVE-2021-4034 (PwnKit) Lab Omgeving Setup"
Write-Host "===================================================="

Test-Prerequisites
New-NatNetwork # Changed from New-HostOnlyNetwork
New-VM -vmName $VM_KALI_NAME -vdiPath $VDI_KALI_PATH -osType "Debian_64"
New-VM -vmName $VM_VULN_NAME -vdiPath $VDI_VULN_PATH -osType "Ubuntu_64"

Write-Info "Starten van VM's..."
VBoxManage startvm $VM_KALI_NAME --type gui
VBoxManage startvm $VM_VULN_NAME --type gui