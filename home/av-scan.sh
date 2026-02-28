#!/usr/bin/env bash
# ClamAV Scan Wrapper

DB_DIR="$HOME/.clamav-db"
CONF_FILE="$DB_DIR/freshclam.conf"
mkdir -p "$DB_DIR"

if [ ! -f "$CONF_FILE" ]; then
    echo "DatabaseDirectory $DB_DIR" > "$CONF_FILE"
    echo "UpdateLogFile $DB_DIR/freshclam.log" >> "$CONF_FILE"
    echo "LogTime yes" >> "$CONF_FILE"
    echo "Foreground yes" >> "$CONF_FILE"
    echo "DNSDatabaseInfo current.cvd.clamav.net" >> "$CONF_FILE"
    echo "DatabaseMirror database.clamav.net" >> "$CONF_FILE"
fi

freshclam --config-file="$CONF_FILE"

TARGET="${1:-$HOME/Downloads}"
clamscan -r "$TARGET" \
    --database="$DB_DIR" \
    --log="$DB_DIR/scan.log" \
    --bell \
    --infected
