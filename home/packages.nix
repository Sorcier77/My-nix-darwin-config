{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Fonts configuration
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    
    # Debugging tools
    gef
    gdb
    binutils
    # CLI utilities
    ripgrep
    fzf
    lazygit
    pylint
    pay-respects
    
    # Modern CLI tools
    dust        # Better du
    fd          # Better find
    procs       # Better ps
    tokei       # Count lines of code
    tealdeer    # tldr pages
    navi        # Interactive cheatsheets
    
    # SSH
    # openssh replaced by programs.ssh package configuration
    # linter nvim

    vimPlugins.vim-clang-format
    rustfmt
    google-java-format

    # copilot 
    github-copilot-cli
    #wireshark

    # ----------------------------------------------------------------
    # Packages migrated from modules/apps.nix for cross-platform support
    # ----------------------------------------------------------------
    vim
    wget
    curl
    htop
    btop
    tree
    nodejs
    openvpn
    zip
    unzip
    p7zip
    # Development tools
    go
    cmake
    gcc
    llvm
    # Media tools
    ffmpeg
    imagemagick
    # Network tools
    nmap
    # Databases
    mysql84
    sqlite
    # Python
    python312
    # Document tools
    typst
    graphviz
    obsidian
    pandoc
    texliveSmall
    
    # --- Hardware / Optimization (X1 Carbon Gen 12) ---
    powertop
    intel-gpu-tools
    libva-utils
    vulkan-tools
    nvtopPackages.intel
    lm_sensors
    pciutils
    usbutils
    fastfetch

    # --- Security / Hardening / Privacy ---
    keepassxc           # Coffre-fort de mots de passe (Offline)
    yubikey-manager     # Gestion YubiKey
    yubikey-personalization
    
    # Chiffrement & Données
    gnupg               # PGP standard
    age                 # Chiffrement moderne (plus simple que GPG)
    tomb                # Création de dossiers chiffrés (Wrapper LUKS) - Idéal pour dossiers sensibles
    srm                 # Secure Remove (écrasement des données)
    mat2                # Nettoyage métadonnées (OpSec)
    
    # Audit & Réseau
    lynis               # Audit de sécurité système complet
    vulnix              # Scan de vulnérabilités (CVE) des paquets Nix installés
    clamav              # Antivirus CLI (Scan fichiers suspects)
    termshark           # Interface Terminal pour Wireshark
    tor-browser         # Navigation anonyme
    onionshare          # Partage de fichiers via Tor

    # --- Ultimate CLI Experience ---
    bat-extras.batman   # Man pages with syntax highlighting
    bat-extras.batgrep  # Grep with syntax highlighting
    bat-extras.batdiff  # Diff with syntax highlighting

    # --- Réseau & Privacy Avancé ---
    macchanger          # Usurpation d'adresse MAC (Indispensable Cyber)
    
    # --- Backup ---
    pika-backup         # Backup données (dédupliqué/chiffré) - Complément idéal aux snapshots BTRFS
  ];
}
