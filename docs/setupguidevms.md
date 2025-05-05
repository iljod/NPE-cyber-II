# Setupgids NPE-Cyber-II

Deze gids laat zien hoe je met één script je host en twee VM’s (Kali attacker + Ubuntu kwetsbaar) opzet.

## 1. Vereisten op de host

- VirtualBox 6.1+
- Bash, wget, 7z
- Git

## 2. Clone en run setup‐script

## 2.1 het dearchiveren werkt niet

het déarchiveren werkt op dit moment nog niet automatisch, dus ik verwijs jullie naar:

Download VDI's: Ga naar osboxes.org en download:
Kali Linux VDI: [kali linux install](https://sourceforge.net/projects/osboxes/files/v/vb/25-Kl-l-x/2024.4/64bit.7z/download)
Download deze vdi en noem het kali.vdi, en sla het op in NPE-cyber-II/vms/setup/vbox_disks

Vulnerable OS VDI: [Ubuntu server 18.04 download](https://sourceforge.net/projects/osboxes/files/v/vb/59-U-u-svr/18.04/18.04.6/64bit.7z/download)
Download deze vdi en noem het ubuntu.vdi, en sla het op in NPE-cyber-II/vms/setup/vbox_disks

## 2.2 automatische setup van de vm's

```bash
git clone git@github.com:iljod/NPE-cyber-II #vanaf dat de deadline verstreken is zal ik de repo publiek zetten, zodat de profs ook zo te werk kunnen gaan
cd NPE-cyber-II/setup
chmod +x auto_setup_vms.sh
./auto_setup_vms.sh
```

_Het script maakt `vboxnet0` aan en (re)creëert:_

- `Kali_Attacker_PwnKit`
- `Ubuntu_Vulnerable_PwnKit`

## 3. Ubuntu VM configureren

1. Log in op `Ubuntu_Vulnerable_PwnKit` via GUI (gebruikersnaam/wachtw: osboxes/osboxes.org).
2. Maak SSH-gebruiker aan:
   ```bash
   sudo useradd -m tester
   echo 'tester:testerpwd' | sudo chpasswd
   ```
3. Installeer en start SSH:
   ```bash
   sudo apt update
   sudo apt install -y openssh-server
   sudo systemctl enable --now ssh
   sudo ufw allow 22/tcp      # open poort 22 voor SSH
   ```
4. Noteer het IP:
   ```bash
   ip -4 addr show scope global | grep -oP 'inet \K[\d.]+'
   ```

## 4. Kali VM voorbereiden

1. Log in op `Kali_Attacker_PwnKit` via GUI (osboxes/osboxes).
2. Nu zijn beiden vm's compleet klaargezet voor de exploit.
