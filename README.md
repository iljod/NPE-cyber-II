# CVE-2021-4034 (PwnKit) Lab Omgeving

[![Licentie: MIT](https://img.shields.io/badge/Licentie-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![VirtualBox](https://img.shields.io/badge/VirtualBox-6.1+-blue.svg)](https://www.virtualbox.org/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-18.04-orange.svg)](https://ubuntu.com/)
[![Kali](https://img.shields.io/badge/Kali-2024.4-red.svg)](https://www.kali.org/)

## 🎯 Overzicht

Deze repository bevat een complete lab-omgeving voor het bestuderen en oefenen van de exploitatie van CVE-2021-4034 (PwnKit), een kritieke privilege-escalatie kwetsbaarheid in de pkexec-component van Polkit. Het lab bestaat uit twee virtuele machines:

- **Aanval-VM**: Kali Linux 2024.4
- **Kwetsbare-VM**: Ubuntu Server 18.04

## 🧠 Technische Achtergrond

### Kwetsbaarheidsdetails
- **CVE ID**: CVE-2021-4034
- **CVSS Score**: 7.8 (Hoog)
- **Type**: Lokale Privilege Escalatie (LPE)
- **Getroffen Component**: pkexec (Polkit)
- **Ontdekking**: Qualys Security (25 januari 2022)

### Impact
De kwetsbaarheid stelt een lokale aanvaller met beperkte rechten in staat om root-toegang te krijgen op het systeem. Dit is bijzonder gevaarlijk omdat:
- Het een kern-systeemcomponent (Polkit) betreft
- Het kan worden misbruikt door elke lokale gebruiker
- Het leidt tot volledige systeemcompromittering

#### waarom het maar een 7.8 is?

- Het is enkel een kwetsbaarheid voor lokale aanvallen, dus je moet al SSH toegang hebben tot de machine

## 🚀 Aan de Slag

1. **Vereisten**
   - VirtualBox 6.1 of hoger
   - 8GB RAM minimum (4GB per VM)
   - 20GB vrije schijfruimte
   - Git

2. **Gedetailleerde Setup**
   Zie [Setup Gids](docs/setupguidevms.md) voor gedetailleerde instructies.

## 📚 Documentatie

- [Setup Gids](docs/setupguidevms.md) - Gedetailleerde VM setup instructies
- [Exploit Gids](docs/exploitguide.md) - Stap-voor-stap exploitatie handleiding
- [Technische Analyse](docs/technical_analysis.md) - Uitgebreide kwetsbaarheidsanalyse

## 🔒 Veiligheidsverklaring

Deze lab-omgeving is alleen bedoeld voor educatieve doeleinden. De exploit-code en technieken mogen alleen worden gebruikt in gecontroleerde omgevingen met de juiste autorisatie.

## 🙏 Dankbetuigingen

- Originele kwetsbaarheidsontdekking: Qualys Security
- Exploit code: [cd80-ctf](https://github.com/cd80-ctf/CVE-2021-4034)
