#!/usr/bin/env bash
# Script d'Active Response pour Wazuh + YARA
# Doit être copié dans /var/ossec/active-response/bin/

LOG_FILE="/var/ossec/logs/active-responses.log"
YARA_BIN="/run/current-system/sw/bin/yara" # Path NixOS/HomeManager
RULES="/home/orion/.yara-rules/index.yar"

# Lire l'input JSON de Wazuh
read -r INPUT
FILENAME=$(echo "$INPUT" | jq -r '.parameters.extra_args[0]')

if [ -f "$FILENAME" ]; then
    echo "$(date) [YARA] Scanning $FILENAME" >> "$LOG_FILE"
    RESULT=$("$YARA_BIN" -w "$RULES" "$FILENAME")
    
    if [ -n "$RESULT" ]; then
        echo "$(date) [YARA] 🛡️ ALERT: $RESULT" >> "$LOG_FILE"
        # Ici on pourrait envoyer une alerte personnalisée à Wazuh via logger
        logger -t wazuh-yara "Malware detected by YARA: $RESULT"
    fi
fi
