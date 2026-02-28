#!/usr/bin/env bash
# YARA Scan Wrapper

RULES_DIR="$HOME/.yara-rules"
mkdir -p "$RULES_DIR"

update_rules() {
    curl -s -L https://raw.githubusercontent.com/Neo23x0/signature-base/master/yara/general_index.yar -o "$RULES_DIR/index.yar"
}

if [ ! -f "$RULES_DIR/index.yar" ] || [ -n "$(find "$RULES_DIR/index.yar" -mtime +7)" ]; then
    update_rules
fi

TARGET="${1:-$HOME/Downloads}"
if [ ! -d "$TARGET" ] && [ ! -f "$TARGET" ]; then
    exit 1
fi

yara -r -w "$RULES_DIR/index.yar" "$TARGET"
