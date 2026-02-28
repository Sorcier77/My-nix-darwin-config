#!/usr/bin/env bash
# Wazuh Active Response - YARA Scan
# Must be copied to /var/ossec/active-response/bin/

LOG_FILE="/var/ossec/logs/active-responses.log"
YARA_BIN="/run/current-system/sw/bin/yara"
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
