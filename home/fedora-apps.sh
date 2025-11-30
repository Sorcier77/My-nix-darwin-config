#!/bin/bash

# =============================================================================
#  Fedora DNF Application Installer
#  Installs desktop applications that are better managed by DNF/RPM than Nix.
#  Excludes: Google Chrome, VS Code, Gamescope, Mangohud (User request).
# =============================================================================

echo "📦 Installing Fedora Desktop Applications..."

# Ensure RPM Fusion is enabled (often required for Discord, etc.)
if ! dnf repolist | grep -q "rpmfusion-nonfree"; then
    echo "⚠️  RPM Fusion Non-Free repository not found. Enabling..."
    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf groupupdate core
fi

# List of packages to install
APPS=(
    # Communication
    discord

    # Office & Productivity
    libreoffice
    simple-scan

    # File Sharing
    deluge

    # Emulation / Compatibility
    bottles
    
    # Virtualization & Networking
    virt-manager
    gns3-gui
    gns3-server
    wireshark
)

echo "Installing: ${APPS[*]}"
sudo dnf install -y "${APPS[@]}"

echo "✅ Installation complete."
