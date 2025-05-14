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
$NETWORK_NAME = "vboxnet0"

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

function New-HostOnlyNetwork {
    Write-Info "Aanmaken van host-only netwerk..."

    $ifExists = VBoxManage list hostonlyifs | Select-String $NETWORK_NAME

    if (-not $ifExists) {
        $output = $null
        $errorMsg = $null
        try {
            $output = VBoxManage hostonlyif create 2>&1
        } catch {
            $errorMsg = $_.Exception.Message
        }
        # Robustly search all output lines for the interface creation message
        $createdName = ($output | ForEach-Object {
            if ($_ -match "Interface '(.+?)' was successfully created") {
                Write-Output $matches[1]
            }
        } | Where-Object { $_ })

        if ($createdName) {
            Write-Info "Host-only netwerk aangemaakt: $createdName"
            # Probeer de adapter te hernoemen als de naam niet overeenkomt
            if ($createdName -ne $NETWORK_NAME) {
                try {
                    VBoxManage hostonlyif remove $NETWORK_NAME 2>$null
                } catch {}
                try {
                    VBoxManage hostonlyif rename $createdName $NETWORK_NAME
                    Write-Info "Adapter hernoemd naar $NETWORK_NAME"
                } catch {
                    Write-WarningCustom "Kon adapter niet hernoemen naar $NETWORK_NAME. Gebruik $createdName in VM-instellingen."
                }
            }
        } else {
            Write-ErrorCustom "Kon geen host-only netwerk aanmaken."
            if ($output) {
                Write-Host "[VBoxManage output] $output" -ForegroundColor Red
            }
            if ($errorMsg) {
                Write-Host "[Exception] $errorMsg" -ForegroundColor Red
            }
            exit 1
        }
    } else {
        Write-Info "Host-only netwerk $NETWORK_NAME bestaat al."
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
        --nic1 intnet `
        --intnet1 "pwn-network" `
        --nicpromisc1 allow-all

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
New-HostOnlyNetwork
New-VM -vmName $VM_KALI_NAME -vdiPath $VDI_KALI_PATH -osType "Debian_64"
New-VM -vmName $VM_VULN_NAME -vdiPath $VDI_VULN_PATH -osType "Ubuntu_64"

Write-Info "Starten van VM's..."
VBoxManage startvm $VM_KALI_NAME --type gui
VBoxManage startvm $VM_VULN_NAME --type gui

Write-Host "===================================================="
Write-Host "Setup succesvol voltooid!"
Write-Host ""
Write-Host "Volgende stappen:"
Write-Host ("1. Log in op {0} (Inloggegevens: osboxes/osboxes.org)" -f $VM_VULN_NAME)
Write-Host "2. Maak SSH gebruiker aan:"
Write-Host "   sudo useradd -m tester"
Write-Host "   echo 'tester:testerpwd' | sudo chpasswd"
Write-Host "   sudo usermod -aG sudo tester"
Write-Host "3. Configureer SSH:"
Write-Host "   sudo apt update"
Write-Host "   sudo apt install -y openssh-server"
Write-Host "   sudo systemctl enable --now ssh"
Write-Host "   sudo ufw allow 22/tcp"
Write-Host "4. Log in op $VM_KALI_NAME (Inloggegevens: osboxes/osboxes)"
Write-Host "5. Ga verder naar de exploit gids in docs/exploitguide.md"
Write-Host "===================================================="

exit 0
