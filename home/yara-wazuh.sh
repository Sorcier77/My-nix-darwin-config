#!/usr/bin/env bash
# Wazuh Active Response - YARA Scan
# Must be copied to /var/ossec/active-response/bin/

LOG_FILE="/var/ossec/logs/active-responses.log"

if [ -f "/home/orion/.nix-profile/bin/yara" ]; then
    YARA_BIN="/home/orion/.nix-profile/bin/yara"
elif [ -f "/usr/bin/yara" ]; then
    YARA_BIN="/usr/bin/yara"
else
    YARA_BIN="yara"
fi

RULES="/home/orion/.yara-rules/index.yar"

read -r INPUT
FILENAME=$(echo "$INPUT" | jq -r '.parameters.extra_args[0]')

if [ -f "$FILENAME" ]; then
    RESULT=$("$YARA_BIN" -w "$RULES" "$FILENAME")
    if [ -n "$RESULT" ]; then
        echo "$(date) [YARA] ALERT: $RESULT on $FILENAME" >> "$LOG_FILE"
        logger -t wazuh-yara "Malware detected: $RESULT"
    fi
fi
