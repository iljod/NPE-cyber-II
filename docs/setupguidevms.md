# Virtuele Machine Setup Gids

## 📄 Deployment Stappenplan

- Clone de repository: `git clone https://github.com/iljod/NPE-cyber-II.git && cd NPE-cyber-II`
- Download de VirtualBox VDI's voor de VMs van osboxes.org en plaats ze in `setup/vbox_disks` als `kali.vdi` en `ubuntu.vdi`
- Maak de VDI directory aan (indien niet bestaan): `mkdir -p setup/vbox_disks`
- Pak de VDI bestanden uit (indien gecomprimeerd)
- Voer het setup script uit:
  - Linux host: `cd setup && chmod +x setup_environment.sh && sudo ./setup_environment.sh`
  - Windows host: `cd setup && Unblock-File .\setup_environment.ps1 && .\setup_environment.ps1`
- Configureer de Ubuntu VM: `wget -qO- https://raw.githubusercontent.com/iljod/NPE-cyber-II/main/setup/configure_ubuntu_vm.sh | sudo bash`
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
- powershell
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

4. Voer het setup script (Windows host)
   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   cd setup
   Unblock-File .\setup_environment.ps1
   .\setup_environment.ps1
   ```

### Ubuntu VM Configuratie

#### SSH preppen

1. Log in op de Ubuntu VM met de standaard inloggegevens:

   - Gebruikersnaam: `osboxes`
   - Wachtwoord: `osboxes.org`

   en dan in de terminal
```bash
sudo apt install -y openssh-server
sudo systemctl enable --now ssh
sudo ufw allow 22/tcp
```

2. installatie prerequisites op de ubuntu vm
2.1 open een terminal
2.2 voer het configuratiescript uit via GitHub:
   ```bash
   wget -qO- https://raw.githubusercontent.com/iljod/NPE-cyber-II/main/setup/configure_ubuntu_vm.sh | sudo bash
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
   ping  # Ubuntu VM IP

   # Op Ubuntu VM
   ping  # Kali VM IP
   ```

2. Test SSH verbinding:
   ```bash
   # Op Kali VM
   ssh tester@ # Ubuntu VM IP
   # Wachtwoord: testerpwd
   ```

## 📚 Volgende Stappen

- Ga verder naar [Exploit Gids](exploitguide.md) om over de kwetsbaarheid te leren
- Kali Linux 2024.4 (VirtualBox VDI van osboxes.org): https://www.osboxes.org/kali-linux/
- Download Ubuntu Server 18.04 (VirtualBox VDI van osboxes.org): https://www.osboxes.org/ubuntu-server/

