# ========================================
# Custom ZSH Configuration for Home Manager
# ========================================

# Color definitions
RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
BLUE=$'\033[0;34m'
MAGENTA=$'\033[0;35m'
RESET=$'\033[0m'

# ASCII Art Banner
echo "${BLUE}     .       .     .    . "
echo "       .       ${YELLOW} *            ${BLUE} . "
echo "    .   .  .   ${YELLOW} *  *   ${BLUE} ."
echo "              ${YELLOW} *  *        ${BLUE} .  "
echo "  .    .    .   ${YELLOW} *   ${BLUE} .  ."
echo "                ${YELLOW} *${RESET}"
echo "${BLUE}   ____          ${RESET} _ ${BLUE}              "
echo "  / __ \\        ${RESET} (_)${BLUE}                "
echo " | |  | |  _ __   _    ___    _ __  "
echo " | |  | | | '__| | |  / _ \\  | '_ \\ "
echo " | |__| | | |    | | | (_) | | | | |"
echo "  \\____/  |_|    |_|  \\___/  |_| |_|${RESET} "

# ========================================
# Powerlevel10k Configuration
# ========================================
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# ========================================
# Path Exports
# ========================================

# Python (pywal)
export PATH="${PATH}:/Users/anselme/Library/Python/3.11/lib/python/site-packages"

# Hyper Terminal
export PATH="/Applications/Hyper.app/Contents/MacOS:$PATH"

# Tailscale
export PATH="/Applications/Tailscale.app/Contents/MacOS:$PATH"

# IDA Pro
export PATH="/Applications/IDA Professional 9.0.app/Contents/MacOS:$PATH"

# LM Studio CLI
export PATH="$PATH:/Users/Sorcier77/.lmstudio/bin"

# ========================================
# FZF Configuration
# ========================================
# Définir le chemin FZF pour oh-my-zsh
export FZF_BASE="$HOME/.nix-profile/bin/fzf"

# ========================================
# Conda Integration
# ========================================
if [ -f /opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh ]; then
    . /opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh
fi

# ========================================
# SSH Agent
# ========================================
# Start SSH agent and add GitHub key
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/github 2>/dev/null
fi

# ========================================
# Custom Aliases
# ========================================

# Logic Pro workaround
alias free_logic_pro="mv -v ~/Library/Application\\ Support/.lpxuserdata ~/.Trash"

# Better ls (eza) - alternative alias
alias lsa="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

# ========================================
# Tool Initializations
# ========================================

# Pay Respects (replacement for thefuck)
if command -v fuck &> /dev/null; then
    eval $(fuck --alias)
    eval $(fuck --alias fk)
fi
