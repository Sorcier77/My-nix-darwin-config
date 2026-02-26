{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

pkgs.mkShell {
  name = "ctf-cybersecurity-env";

  buildInputs = with pkgs; [
    # === WEB EXPLOITATION ===
    sqlmap
    nikto
    wfuzz
    ffuf
    gobuster
    dirb
    subfinder
    httpx
    nuclei
    feroxbuster
    arjun
    dalfox
    
    # === REVERSE ENGINEERING ===
    ghidra
    radare2
    rizin
    # cutter  # Temporarily disabled due to qtconnectivity build issue on macOS
    gdb
    binwalk
    upx
    
    # === BINARY EXPLOITATION ===
    pwntools
    python313Packages.ropper
    ropgadget
    one_gadget

    # === CRYPTO ===
    python312Packages.pycryptodome
    python312Packages.gmpy2
    python312Packages.cryptography
    hashcat
    hashcat-utils
    hash-identifier
    openssl
    
    # === FORENSICS ===
    volatility3
    sleuthkit
    foremost
    scalpel
    exiftool
    binwalk
    steghide
    zsteg
    outguess
    hexedit
    hexdump
    
    # === NETWORK & RECON ===
    nmap
    rustscan
    tcpdump
    tshark
    netcat
    socat
    theharvester
    dnsenum
    dnsrecon
    fierce
    amass
    
    # === OSINT ===
    sherlock
    holehe
    h8mail
    
    # === PASSWORD CRACKING ===
    hashcat
    crunch
    cewl
    
    # === SCRIPTING & AUTOMATION ===
    python312
    python312Packages.requests
    python312Packages.beautifulsoup4
    python312Packages.pwntools
    python312Packages.scapy
    python312Packages.paramiko
    python312Packages.impacket
    python312Packages.pyftpdlib
    ruby
    perl
    
    # === WIRELESS ===
    aircrack-ng

    # === MOBILE ===
    apktool
    jadx
    dex2jar
    
    # === STEGANOGRAPHY ===
    steghide
    zsteg
    
    # === CLOUD & API ===
    awscli2
    google-cloud-sdk
    azure-cli
    
    # === DOCKER & CONTAINERS ===
    docker
    docker-compose
    
    # === UTILITIES ===
    git
    curl
    wget
    jq
    yq
    ripgrep
    fd
    bat
    fzf
    tmux
    neovim
    file
    
    # === EXPLOIT DEV ===
    msfpc
    shellnoob
    
    # === MODERN TOOLS ===
    # Rust-based modern alternatives
    ripgrep      # better grep
    fd           # better find
    bat          # better cat
    httpie       # modern HTTP client
    
    # Web security
    wapiti
    

    # Kubernetes security
    kubectl
    k9s
    trivy
    
    # Git security
    gitleaks
    trufflehog
    
    # Cloud native
    terraform
    ansible
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    # Linux-only tools (require glibc or Linux kernel features)
    burpsuite
    gef
    patchelf
    ltrace
    strace
    metasploit
    autopsy
    python313Packages.seccomp
    masscan
    hydra
    medusa
    cowpatty
    bully
    reaverwps-t6x
    john
    sage
    checksec
    android-tools
    iaito
    stegseek
  ];
  
  shellHook = ''
    echo "🚀 CTF & Cybersecurity Environment Loaded!"
    echo ""
    echo "📦 Available tool categories:"
    echo "  • Web Exploitation: sqlmap, burpsuite, ffuf, nuclei, feroxbuster"
    echo "  • Reverse Engineering: ghidra, radare2, rizin, cutter, gdb"
    echo "  • Binary Exploitation: pwntools, ropper, ropgadget"
    echo "  • Cryptography: hashcat, john, rsactftool, sage"
    echo "  • Forensics: volatility3, binwalk, steghide, exiftool"
    echo "  • Network: nmap, wireshark, metasploit, rustscan"
    echo "  • Password Cracking: hashcat, john, hydra"
    echo "  • Mobile: apktool, jadx, dex2jar"
    echo "  • OSINT: sherlock, holehe, theharvester"
    echo ""
    echo "💡 Tip: Use 'exit' to leave the CTF environment"
    echo ""
    
    # Set up Python environment
    export PYTHONPATH="${pkgs.python312Packages.pwntools}/lib/python3.12/site-packages:$PYTHONPATH"
    
    # Aliases for common tools
    alias ll='ls -la'
    alias serve='python -m http.server'
    alias rshell='nc -lvnp'
    alias sqlmap-wizard='sqlmap --wizard'
    alias ghidra-headless='ghidra --headless'
    
    # CTF working directory
    export CTF_DIR="$HOME/ctf"
    mkdir -p "$CTF_DIR"
    
    # History
    export HISTFILE="$HOME/.ctf_history"
    export HISTSIZE=10000
  '';
}
