# Virtuele Machine Setup Gids

## 📋 Vereisten

### Systeemvereisten
- **CPU**: Dual-core processor of beter
- **RAM**: 8GB minimum (4GB per VM)
- **Opslag**: 20GB vrije ruimte
- **OS**: Elk host OS dat door VirtualBox wordt ondersteund

### Benodigde Software
- VirtualBox 6.1 of hoger
- Git
- Bash shell
- wget
- 7-Zip (voor het uitpakken van VDI bestanden)

## 🚀 Snelle Start

1. Clone de repository:
   ```bash
   git clone https://github.com/iljod/NPE-cyber-II.git
   cd NPE-cyber-II
   ```

2. Download de benodigde VDI bestanden:
   - Kali Linux 2024.4: [Download](https://www.kali.org/get-kali/#kali-virtual-machines)
   - Ubuntu Server: [Download Ubuntu Server VDI](https://sourceforge.net/projects/osboxes/files/v/vb/59-U-u-svr/18.04/18.04.6/64bit.7z/download)

   Plaats deze bestanden in de `setup/vbox_disks` directory:
   ```bash
   mkdir -p setup/vbox_disks
   # Kopieer de gedownloade VDI bestanden naar setup/vbox_disks/
   # en noem ze kali.vdi en ubuntu.vdi
   ```

3. Pak de VDI bestanden uit:
   ```bash
   cd setup/vbox_disks
   7z x ubuntu.7z
   7z x kali.7z
   ```

4. Voer het setup script uit(Linux host):
   ```bash
   cd setup
   chmod +x setup_environment.sh
   sudo ./setup_environment.sh
   ```
   - of (Windows host)
    ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   cd setup
   Unblock-File .\setup_environment.ps1
   .\setup_environment.ps1
   ```

### 2. Configureer Virtuele Machines (Dit gebeurd al automatisch, maar dit is wat wordt gedaan)

#### Kali Linux (Aanvals-VM)
1. Maak nieuwe VM aan in VirtualBox:
   - Naam: `Kali_Attacker_PwnKit`
   - Type: Linux
   - Versie: Debian (64-bit)
   - Geheugen: 2048 MB
   - Harde schijf: Gebruik bestaande `kali.vdi`

2. Netwerk instellingen:
   - Adapter 1: Host-only Adapter
   - Naam: vboxnet0
   - Promiscuous Mode: Allow All

#### Ubuntu Server (Kwetsbare-VM)
1. Maak nieuwe VM aan in VirtualBox:
   - Naam: `Ubuntu_Vulnerable_PwnKit`
   - Type: Linux
   - Versie: Ubuntu (64-bit)
   - Geheugen: 2048 MB
   - Harde schijf: Gebruik bestaande `ubuntu.vdi`

2. Netwerk instellingen:
   - Adapter 1: Host-only Adapter
   - Naam: vboxnet0
   - Promiscuous Mode: Allow All

## 🔧 Post-Setup Configuratie (Dit gebeurd al automatisch, maar dit is wat wordt gedaan)

### Ubuntu VM Configuratie

1. Log in op de Ubuntu VM met de standaard inloggegevens:
   - Gebruikersnaam: `osboxes`
   - Wachtwoord: `osboxes.org`

2. Voer het configuratiescript uit via GitHub:
   ```bash
   curl -sL https://raw.githubusercontent.com/iljod/NPE-cyber-II/main/setup/configure_ubuntu_vm.sh | sudo bash
   ```

Het script zal automatisch:
- Het systeem updaten
- SSH server installeren
- Een `tester` gebruiker aanmaken
- SSH configureren
- Het IP-adres tonen

### Kali VM Configuratie

1. Inloggegevens:
   - Gebruikersnaam: `osboxes`
   - Wachtwoord: `osboxes`

## ✅ Verificatie

1. Controleer netwerkverbinding:
   ```bash
   # Op Kali VM
   ping 192.168.56.101  # Ubuntu VM IP
   
   # Op Ubuntu VM
   ping 192.168.56.102  # Kali VM IP
   ```

2. Test SSH verbinding:
   ```bash
   # Op Kali VM
   ssh tester@192.168.56.101
   # Wachtwoord: testerpwd
   ```

## 📚 Volgende Stappen
- Ga verder naar [Exploit Gids](exploitguide.md) om over de kwetsbaarheid te leren