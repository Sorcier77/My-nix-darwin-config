#!/usr/bin/env bash
# Script d'Active Response pour Wazuh + YARA
# Doit être copié dans /var/ossec/active-response/bin/

LOG_FILE="/var/ossec/logs/active-responses.log"
YARA_BIN="/run/current-system/sw/bin/yara" # Path NixOS/HomeManager
RULES_DIR="${YARA_RULES_DIR:-$HOME/.yara-rules}"
RULES="$RULES_DIR/index.yar"

# Lire l'input JSON de Wazuh
read -r INPUT

# Vérifier que jq est installé
if ! command -v jq >/dev/null 2>&1; then
    echo "$(date) [YARA] Error: jq is not installed; cannot parse JSON input" >> "$LOG_FILE"
    exit 1
fi

# Valider que l'input est un JSON correct
if ! echo "$INPUT" | jq -e . >/dev/null 2>&1; then
    echo "$(date) [YARA] Error: received malformed JSON input: $INPUT" >> "$LOG_FILE"
    exit 1
fi

# Extraire le nom de fichier depuis le JSON
FILENAME=$(echo "$INPUT" | jq -er '.parameters.extra_args[0]' 2>/dev/null) || {
    echo "$(date) [YARA] Error: unable to extract filename from JSON input" >> "$LOG_FILE"
    exit 1
}

if [ -n "$FILENAME" ] && [ -f "$FILENAME" ]; then
    echo "$(date) [YARA] Scanning $FILENAME" >> "$LOG_FILE"
    RESULT=$("$YARA_BIN" -w "$RULES" "$FILENAME")
    
    if [ -n "$RESULT" ]; then
        echo "$(date) [YARA] 🛡️ ALERT: $RESULT" >> "$LOG_FILE"
        # Ici on pourrait envoyer une alerte personnalisée à Wazuh via logger
        logger -t wazuh-yara "Malware detected by YARA: $RESULT"
    fi
fi
