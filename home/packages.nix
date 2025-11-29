{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # =================================================================
    #  CORE ESSENTIALS & MODERN CLI
    # =================================================================
    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg

    # Nix Tools
    nh          # Nix Helper
    ripgrep     # Grep ultra-rapide
    fzf         # Fuzzy Finder
    lazygit     # Git TUI
    dust        # Usage Disque
    fd          # Find modernisé
    procs       # PS modernisé
    tokei       # Code statistics
    tealdeer    # TLDR pages
    navi        # Cheatsheets interactives
    bat-extras.batman # Man pages colorées
    bat-extras.batgrep # Grep contextuel
    fastfetch   # System Info

    # =================================================================
    #  OFFENSIVE SECURITY & PENTESTING (RED TEAM)
    # =================================================================
    # Web & Recon
    nmap        # Network Mapper (Standard)
    ffuf        # Fast Web Fuzzer (Go) - Indispensable Web Pentest
    gobuster    # Directory/DNS Brute-forcing
    sqlmap      # SQL Injection Automation
    nikto       # Web Server Scanner
    whatweb     # Web Fingerprinter

    # Brute-Force & Cracking
    thc-hydra   # Network Logon Cracker
    john        # Password Cracker (Jumbo)
    hashcat     # Advanced Password Recovery (GPU)

    # Network Attacks & MitM
    dsniff      # arpspoof, etc.
    socat       # Netcat avancé (Relais, Tunnels)

    # =================================================================
    #  FORENSICS, REVERSE & DEFENSE (BLUE TEAM)
    # =================================================================
    # Analyse Binaire & Debug
    radare2     # Reverse Engineering Framework
    gef         # GDB Enhanced Features (Exploit Dev)
    gdb         # GNU Debugger
    binwalk     # Firmware Analysis
    checksec    # Binary Mitigation Checker (NX, PIE, etc.)
    hexedit     # Hex Editor
    
    # Forensics
    exiftool    # Metadata Editor
    sleuthkit   # Filesystem Analysis Tools
    ddrescue    # Data Recovery

    # Analyse Réseau & Audit
    tcpdump     # CLI Packet Analyzer (Root required often)
    ngrep       # Network Grep
    termshark   # TUI for Wireshark
    ssh-audit   # SSH Server Configuration Auditor
    lynis       # System Security Audit
    # rkhunter    # Rootkit Hunter (Missing/Removed from nixpkgs)
    # chkrootkit  # Rootkit Detector (Removed from nixpkgs: unmaintained)
    vulnix      # NixOS/Nix Vulnerability Scanner
    clamav      # Antivirus CLI

    # =================================================================
    #  SECURITY & HARDWARE (MINARM / GOV COMPLIANT)
    # =================================================================
    # Smartcards & YubiKey
    yubikey-manager
    yubikey-personalization
    opensc      # Smartcard tools (CAC/PIV support)
    ccid        # Generic USB CCID smart card reader driver
    pcsclite    # Middleware to access a smart card using PC/SC

    # Chiffrement & Privacy
    gnupg       # GPG
    age         # Modern File Encryption
    tomb        # Crypto-folders (LUKS wrapper)
    srm         # Secure Remove (DoD standard compliance)
    mat2        # Metadata Anonymisation Toolkit
    tor-browser # Anonymity
    onionshare  # Secure File Sharing

    # =================================================================
    #  DEV & UTILITIES
    # =================================================================
    # Langages & Build
    python312
    nodejs
    go
    gcc
    cmake
    gnumake
    
    # Tools
    vim
    wget
    curl
    htop
    btop
    tree
    zip
    unzip
    p7zip
    jq          # JSON Processor (Indispensable pour APIs)
    
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # =================================================================
    #  LINUX ONLY TOOLS (Kernel/Hardware Dependent)
    # =================================================================
    strace      # System Call Tracer (Linux only)
    ltrace      # Library Call Tracer (Linux only)
    firejail    # Sandboxing (Linux only namespaces)
    
    # Hardware Opti
    powertop
    lm_sensors
    pciutils    # lspci
    usbutils    # lsusb
    intel-gpu-tools
    libva-utils
    vulkan-tools
    
    # Utilities
    wl-clipboard # Wayland Clipboard Support

    # Network/Mac (Specific implementations)
    macchanger
  ];
}
