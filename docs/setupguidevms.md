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
   git clone https://github.com/yourusername/NPE-cyber-II.git
   cd NPE-cyber-II
   ```

2. Maak de benodigde mappen aan:
   ```bash
   mkdir -p vms/setup/vbox_disks
   cd vms/setup/vbox_disks
   ```

3. Download de VM images:
   - Kali Linux: [Download Kali Linux VDI](https://sourceforge.net/projects/osboxes/files/v/vb/25-Kl-l-x/2024.4/64bit.7z/download)
   - Ubuntu Server: [Download Ubuntu Server VDI](https://sourceforge.net/projects/osboxes/files/v/vb/59-U-u-svr/18.04/18.04.6/64bit.7z/download)

4. Pak uit en hernoem de bestanden:
   ```bash
   7z x 64bit.7z
   mv "Kali Linux 2024.4 64bit.vdi" kali.vdi
   mv "Ubuntu Server 18.04.6 64bit.vdi" ubuntu.vdi
   ```

5. Plaats de VDI bestanden in de `vbox_disks` map.

6. Voer het geautomatiseerde setup script uit:
   ```bash
   cd ../..
   chmod +x auto_setup_vms.sh
   ./auto_setup_vms.sh
   ```

### 2. Configureer Virtuele Machines (Dit gebeurd al automatisch, maar dit is wat wordt gedaan)

#### Kali Linux (Aanvals-VM)
1. Maak nieuwe VM aan in VirtualBox:
   - Naam: `Kali_Attacker_PwnKit`
   - Type: Linux
   - Versie: Debian (64-bit)
   - Geheugen: 2048 MB
   - Harde schijf: Gebruik bestaande `kali.vdi`

2. Netwerkinstellingen:
   - Adapter 1: Host-only Adapter (vboxnet0)
   - Promiscuous Mode: Allow All

#### Ubuntu Server (Kwetsbare-VM)
1. Maak nieuwe VM aan in VirtualBox:
   - Naam: `Ubuntu_Vulnerable_PwnKit`
   - Type: Linux
   - Versie: Ubuntu (64-bit)
   - Geheugen: 2048 MB
   - Harde schijf: Gebruik bestaande `ubuntu.vdi`

2. Netwerkinstellingen:
   - Adapter 1: Host-only Adapter (vboxnet0)
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

1. Test netwerkverbinding tussen VM's:
   ```bash
   # Op Kali VM
   ping <ubuntu_ip>
   
   # Op Ubuntu VM
   ping <kali_ip>
   ```

2. Test SSH toegang:
   ```bash
   # Op Kali VM
   ssh tester@<ubuntu_ip>
   ```

## 📚 Volgende Stappen
- Ga verder naar [Exploit Gids](exploitguide.md) om over de kwetsbaarheid te leren