#!/usr/bin/env bash
# Script wrapper pour YARA
# Usage: yara-scan [dossier]

RULES_DIR="$HOME/.yara-rules/signature-base"

# Téléchargement/Mise à jour des règles (Florian Roth - Neo23x0 est une référence)
update_rules() {
    echo "📥 Mise à jour des règles YARA (Signature-Base)..."
    if [ -d "$RULES_DIR/.git" ]; then
        # Mettre à jour le dépôt existant
        git -C "$RULES_DIR" pull --ff-only
    else
        # Cloner le dépôt complet (shallow pour limiter la taille)
        mkdir -p "$(dirname "$RULES_DIR")"
        git clone --depth=1 https://github.com/Neo23x0/signature-base.git "$RULES_DIR"
    fi
    echo "✅ Règles YARA mises à jour."
}

# Si le dépôt n'existe pas ou a plus de 7 jours, on met à jour
if [ ! -d "$RULES_DIR/.git" ] || [ -n "$(find "$RULES_DIR/.git/FETCH_HEAD" -mtime +7 2>/dev/null)" ]; then
    update_rules
fi

INDEX_FILE="$RULES_DIR/yara/general_index.yar"

TARGET="${1:-$HOME/Downloads}"

if [ ! -d "$TARGET" ] && [ ! -f "$TARGET" ]; then
    echo "❌ Erreur : Le dossier ou fichier '$TARGET' n'existe pas."
    exit 1
fi

echo "🔍 Scan YARA en cours sur : $TARGET"
echo "   (Utilisation des règles locales : $INDEX_FILE)"

# Scan récursif
# -r : récursif, -w : pas d'avertissements
yara -r -w "$INDEX_FILE" "$TARGET"

echo "✅ Scan terminé."
