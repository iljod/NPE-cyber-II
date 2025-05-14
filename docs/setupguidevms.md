# Virtuele Machine Setup Gids

## 📄 Deployment Stappenplan

- Clone de repository: `git clone https://github.com/iljod/NPE-cyber-II.git && cd NPE-cyber-II`
- Download de VirtualBox VDI's voor de VMs van osboxes.org en plaats ze in `setup/vbox_disks` als `kali.vdi` en `ubuntu.vdi`
- Maak de VDI directory aan (indien niet bestaan): `mkdir -p setup/vbox_disks`
- Pak de VDI bestanden uit (indien gecomprimeerd)
- Voer het setup script uit:
  - Linux host: `cd setup && chmod +x setup_environment.sh && sudo ./setup_environment.sh`
  - Windows host: `cd setup && Unblock-File .\setup_environment.ps1 && .\setup_environment.ps1`
- Configureer de Ubuntu VM: `curl -sL https://raw.githubusercontent.com/iljod/NPE-cyber-II/main/setup/configure_ubuntu_vm.sh | sudo bash`
- Verifieer de installatie met `./test_polkit_vuln.sh`

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

   - Kali Linux 2024.4 (VirtualBox VDI van osboxes.org): https://www.osboxes.org/kali-linux/
   - Ubuntu Server 18.04 (VirtualBox VDI van osboxes.org): https://www.osboxes.org/ubuntu-server/

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
   ```(manueel uitpakken indien windows 7z niet kan vinden.)

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

### Ubuntu VM Configuratie

1. Log in op de Ubuntu VM met de standaard inloggegevens:

   - Gebruikersnaam: `osboxes`
   - Wachtwoord: `osboxes.org`

2. installatie prerequisites op de ubuntu vm
2.1 open een terminal
2.2 voer de volgende commando uit:
```bash
sudo apt install curl
```
2.3 voer het configuratiescript uit via GitHub:
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
   - Wachtwoord: `osboxes.org`

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

## 🔍 Test Polkit Kwetsbaarheid

1. Kopieer het test script naar de Ubuntu VM:

   ```bash
   # Op Kali VM
   scp setup/test_polkit_vuln.sh tester@192.168.56.101:~/
   ```

2. Voer het test script uit op de Ubuntu VM:

   ```bash
   # Op Ubuntu VM
   chmod +x test_polkit_vuln.sh
   ./test_polkit_vuln.sh
   ```

3. Interpreteer de resultaten:
   - Als het systeem kwetsbaar is, zul je een rode waarschuwing zien
   - Het script zal automatisch controleren op:
     - SUID-bit instellingen
     - GCONV_PATH manipulatie mogelijkheid
     - Aanwezigheid van gconv-modules
   - Voor kwetsbare systemen wordt een update naar polkit 0.105 of hoger aanbevolen

## 📚 Volgende Stappen

- Ga verder naar [Exploit Gids](exploitguide.md) om over de kwetsbaarheid te leren
- Kali Linux 2024.4 (VirtualBox VDI van osboxes.org): https://www.osboxes.org/kali-linux/
- Download Ubuntu Server 18.04 (VirtualBox VDI van osboxes.org): https://www.osboxes.org/ubuntu-server/

