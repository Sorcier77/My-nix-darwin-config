#!/usr/bin/env bash
# Script wrapper pour YARA
# Usage: yara-scan [dossier]

RULES_DIR="$HOME/.yara-rules"
mkdir -p "$RULES_DIR"

# Téléchargement/Mise à jour des règles (Florian Roth - Neo23x0 est une référence)
update_rules() {
    echo "📥 Mise à jour des règles YARA (Signature-Base subset)..."
    # On récupère un index de règles fiables pour éviter de tout cloner (plusieurs GB sinon)
    curl -s -L https://raw.githubusercontent.com/Neo23x0/signature-base/master/yara/general_index.yar -o "$RULES_DIR/index.yar"
    # Note: Dans un setup complet, on clonerait le repo, mais pour un début, l'index suffit si on pointe les URLs
    echo "✅ Index des règles mis à jour."
}

# Si l'index n'existe pas ou a plus de 7 jours, on met à jour
if [ ! -f "$RULES_DIR/index.yar" ] || [ -n "$(find "$RULES_DIR/index.yar" -mtime +7)" ]; then
    update_rules
fi

TARGET="${1:-$HOME/Downloads}"

if [ ! -d "$TARGET" ] && [ ! -f "$TARGET" ]; then
    echo "❌ Erreur : Le dossier ou fichier '$TARGET' n'existe pas."
    exit 1
fi

echo "🔍 Scan YARA en cours sur : $TARGET"
echo "   (Utilisation des règles locales : $RULES_DIR/index.yar)"

# Scan récursif
# -r : récursif, -w : pas d'avertissements, -p : nombre de threads (facultatif mais aide la perf)
yara -r -w "$RULES_DIR/index.yar" "$TARGET"

echo "✅ Scan terminé."
