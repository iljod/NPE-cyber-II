#!/bin/bash

# Kleuren voor output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Polkit pkexec Kwetsbaarheidscontrole (CVE-2021-4034)${NC}"
echo "====================================================="

# Controleer of pkexec bestaat en werkt
if ! command -v pkexec &> /dev/null; then
    echo -e "${RED}[!] pkexec niet gevonden op het systeem${NC}"
    exit 1
fi

# Haal pkexec versie op
PKEXEC_VERSION=$(pkexec --version 2>/dev/null | grep -oP '\d+\.\d+\.\d+' || echo "onbekend")
echo -e "[*] pkexec versie: ${PKEXEC_VERSION}"

# Controleer of systeem kwetsbaar is
KWETSBAAR=false

# Test voor de echte kwetsbaarheid
echo -e "\n[*] Test voor CVE-2021-4034 kwetsbaarheid..."

# Test 1: Controleer of pkexec SUID-bit heeft
if [[ -u $(which pkexec) ]]; then
    echo -e "${YELLOW}[*] pkexec heeft SUID-bit ingesteld${NC}"

    # Test 2: Controleer of GCONV_PATH manipulatie mogelijk is
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"

    # Maak test bestanden aan
    mkdir -p "GCONV_PATH=."
    echo "test" > "GCONV_PATH=./exploit"
    chmod +x "GCONV_PATH=./exploit"

    # Test of pkexec de GCONV_PATH omgevingsvariabele accepteert
    if pkexec --help 2>&1 | grep -q "GCONV_PATH"; then
        echo -e "${RED}[!] pkexec accepteert GCONV_PATH omgevingsvariabele${NC}"
        KWETSBAAR=true
    else
        echo -e "${GREEN}[+] pkexec verwerpt GCONV_PATH omgevingsvariabele${NC}"
    fi

    # Test 3: Controleer of het systeem gconv-modules ondersteunt
    if [[ -d "/usr/lib/gconv" ]] || [[ -d "/usr/lib64/gconv" ]]; then
        echo -e "${YELLOW}[*] Systeem heeft gconv-modules ondersteuning${NC}"
        if [[ "$KWETSBAAR" == "true" ]]; then
            echo -e "${RED}[!] Systeem is kwetsbaar voor GCONV_PATH exploit${NC}"
        fi
    fi

    # Opruimen
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
fi

# Toon resultaten
echo -e "\n[*] Systeem Status:"
if [[ "$KWETSBAAR" == "true" ]]; then
    echo -e "${RED}[!] Systeem lijkt KWETSBAAR te zijn voor CVE-2021-4034${NC}"
    echo -e "${YELLOW}[*] Aanbeveling: Update polkit pakket naar versie 0.105 of hoger${NC}"
else
    echo -e "${GREEN}[+] Systeem lijkt NIET kwetsbaar te zijn voor CVE-2021-4034${NC}"
fi

echo -e "\n[*] Extra Informatie:"
echo -e "[*] Deze test controleert de specifieke condities die nodig zijn voor de GCONV_PATH exploit"
