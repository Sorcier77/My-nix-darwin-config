#!/usr/bin/env bash
# Script wrapper pour ClamAV en mode utilisateur (Home Manager)
# Usage: av-scan [dossier]

DB_DIR="$HOME/.clamav-db"
CONF_FILE="$DB_DIR/freshclam.conf"
mkdir -p "$DB_DIR"

# Création config freshclam si inexistante
if [ ! -f "$CONF_FILE" ]; then
    echo "DatabaseDirectory $DB_DIR" > "$CONF_FILE"
    echo "UpdateLogFile $DB_DIR/freshclam.log" >> "$CONF_FILE"
    echo "LogTime yes" >> "$CONF_FILE"
    echo "Foreground yes" >> "$CONF_FILE"
    echo "DNSDatabaseInfo current.cvd.clamav.net" >> "$CONF_FILE"
    echo "DatabaseMirror database.clamav.net" >> "$CONF_FILE"
fi

echo "🔍 Mise à jour de la base virale..."
freshclam --config-file="$CONF_FILE"

TARGET="${1:-$HOME/Downloads}"
echo "🛡️  Scan en cours sur : $TARGET"
echo "    (Cela peut prendre du temps...)"

clamscan -r "$TARGET" \
    --database="$DB_DIR" \
    --log="$DB_DIR/scan.log" \
    --bell \
    --infected

echo "✅ Terminé. Log : $DB_DIR/scan.log"
