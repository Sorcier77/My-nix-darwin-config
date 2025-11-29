{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "ctf-env";
  
  nativeBuildInputs = with pkgs; [
    zsh
    eza
    # --- Binary Exploitation & Pwn (Zardus style) ---
    gdb
    # pwndbg            # Powerful GDB extension (Temporarily disabled: package not found in nixpkgs)
    gef               # Another GDB extension (good for heap)
    ropgadget         # Gadget finder
    # ropper            # Alternative gadget finder (redundant, in python packages)
    one_gadget        # Magic gadget finder
    rubyPackages.seccomp-tools     # Analyze seccomp filters
    patchelf          # Modify ELF binaries
    elfutils
    ltrace
    strace
    checksec

    # --- Reverse Engineering ---
    radare2
    rizin
    ghidra            # NSA tool suite
    binwalk           # Firmware analysis
    apktool           # Android
    frida-tools       # Dynamic instrumentation
    capstone          # Disassembly framework
    keystone          # Assembly framework
    unicorn           # CPU emulator

    # --- Web Security ---
    burpsuite         # Intercepting Proxy
    zap               # OWASP ZAP
    nuclei            # Template-based vulnerability scanner
    sqlmap            # SQL Injection
    ffuf              # Fast web fuzzer
    gobuster          # Directory brute-forcing
    wpscan            # WordPress Scanner
    nikto
    mitmproxy
    httpie
    curl
    wget

    # --- Forensics & Steganography ---
    volatility3       # Memory forensics
    sleuthkit         # Disk forensics
    autopsy           # GUI for Sleuthkit
    foremost          # File carving
    exiftool          # Metadata
    zsteg             # PNG/BMP stego
    steghide
    pngcheck
    ffmpeg

    # --- Cryptography & Cracking ---
    john              # Password cracker
    hashcat           # Advanced password recovery
    thc-hydra         # Network login cracker
    cyberchef         # The Swiss Army Knife
    xortool           # XOR analysis
    fcrackzip

    # --- Network Scanning & Pivoting ---
    nmap
    rustscan          # Faster Nmap
    naabu             # Fast port scanner (ProjectDiscovery)
    masscan           # Mass IP scanner
    wireshark
    tcpdump
    netcat-gnu
    socat
    chisel            # TCP Tunneling / Pivoting
    sshuttle          # VPN over SSH (Poor man's VPN)
    bettercap         # MITM framework
    aircrack-ng       # WiFi auditing

    # --- Active Directory & Windows Attacks ---
    metasploit        # The Framework
    kerbrute          # Kerberos pre-auth bruteforcing
    evil-winrm        # WinRM shell
    samba             # smbclient etc.
    cifs-utils        # mounting smb
    # Note: Impacket is in Python packages

    # --- 6. OSINT & RECONNAISSANCE FRAMEWORKS ---
    # spiderfoot        # Automated OSINT collection (The "scanner" approach) (Missing)
    maltego           # Link analysis & visualization (The "graph" approach)
    recon-ng          # Web Reconnaissance framework (The "Metasploit" approach)
    amass             # In-depth DNS enumeration & matching
    maigret
    
    # --- 7. TARGETED OSINT TOOLS ---
    sherlock          # Username search
    # maigret           # Advanced username search (often better than Sherlock) (Dependency pyhanko failed build)
    theharvester      # Email/Domain gathering
    python3Packages.shodan            # Search engine for devices (CLI)
    ghunt             # Google Account OSINT (Extract data from emails/GaiaIDs)
    holehe            # Check if email is attached to accounts (without login)
    socialscan        # Check email/username availability
    metadata-cleaner  # Clean metadata before sharing

    # --- 8. MISC & UTILS ---
    jq                # JSON processor
    yara              # Pattern matching
    ripgrep           # Fast grep
    fd                # Fast find
    bat               # Cat with wings
    tmux              # Terminal multiplexer (essential for multi-tasking)

    # --- Python Environment (Essential libs) ---
    (python3.withPackages (ps: with ps; [
      pwntools        # CTF framework standard
      pycryptodome    # Crypto
      requests
      scapy           # Network packet manipulation
      impacket        # Network protocols
      z3-solver       # Theorem prover
      
      # AI & Automation
      google-generativeai # Le SDK officiel Gemini
      langchain
      langchain-community
      pandas
      numpy

      ipython         # Interactive shell
      tqdm
      pillow
      beautifulsoup4
      ropper
      unicorn
      capstone
      keystone-engine
    ]))
  ];

  shellHook = ''
    # Red prompt for "Attack Mode" to clearly distinguish from normal shell
    export PS1="\n[\033[1;31m][🚩 CTF-MODE:\w]\$ [\033[0m] "
    
    # Aliases for Bash (fallback)
    alias ls='eza --icons=auto' 
    alias ll='eza -la --icons=auto'
    alias grep='grep --color=auto'

    echo "💀 CTF Environment Loaded 💀"
    echo "Tools: Pwn, Reverse, Crypto, Web, OSINT"
    echo "Specific Opti: X1 Carbon Gen 12"

    # Launch ZSH if available for full user experience
    if command -v zsh >/dev/null 2>&1;
      then
      export CTF_MODE=1
      exec zsh
    fi
  '';
}
