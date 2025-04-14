intro readme

CVE-2021-4034, ook bekend als "PwnKit", is een kwetsbaarheid in de pkexec-tool van Polkit, een component dat veel wordt gebruikt in Linux-systemen voor het beheren van access rights. Deze kwetsbaarheid stelt een lokale gebruiker zonder speciale rechten in staat om rootrechten te verkrijgen, wat leidt tot een volledige compromittering van het systeem.

🧠 Technische Analyse van CVE-2021-4034

Kwetsbaar component: pkexec (onderdeel van Polkit)
CVE-ID: CVE-2021-4034
Type kwetsbaarheid: Out-of-bounds write / lokale privilege-escalatie
CVSS-score: 7.8 (High)
Ontdekt door: Qualys Security
Datum openbaar gemaakt: 25 januari 2022

De kwetsbaarheid is een Local Privilege Escalation (LPE). Dit betekent dat een aanvaller die al beperkte toegang heeft tot een Linux-systeem (bijvoorbeeld via een webserver-exploit, een gestolen SSH-wachtwoord, of fysieke toegang als gastgebruiker) deze kwetsbaarheid kan misbruiken om volledige root-rechten te verkrijgen op dat systeem.

Hoe werkt het technisch? (Vereenvoudigd)

Doel: Twee VMs in VirtualBox:

    Een "Vulnerable VM" met een oude Linux-versie waarop een kwetsbare pkexec draait.

    Een "Attacker VM" met Kali Linux.
    Automatisatie via VBoxManage en bash scripts voor het opzetten van de VMs.

Stap 1: Voorbereiding (Host Machine)

    Installeer VirtualBox: Zorg dat VirtualBox geïnstalleerd is op je host systeem.

    Download VDI's: Ga naar osboxes.org en download:

        Kali Linux VDI: (osboxes)[https://www.osboxes.org/kali-linux/]

        Vulnerable OS VDI:

    Plaats VDI's: Plaats de gedownloade .vdi bestanden op een logische locatie op je host machine.
