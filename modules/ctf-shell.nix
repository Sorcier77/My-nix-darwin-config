{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "ctf-env";

  nativeBuildInputs = with pkgs; [
    zsh
    eza
    # --- Binary Exploitation & Pwn (Zardus style) ---
    gdb
    # pwndbg            # Powerful GDB extension (Temporarily disabled: package not found in nixpkgs)
    gef # Another GDB extension (good for heap)
    ropgadget # Gadget finder
    # ropper            # Alternative gadget finder (redundant, in python packages)
    one_gadget # Magic gadget finder
    rubyPackages.seccomp-tools # Analyze seccomp filters
    patchelf # Modify ELF binaries
    elfutils
    ltrace
    strace
    checksec

    # --- Reverse Engineering ---
    radare2
    rizin
    ghidra # NSA tool suite
    binwalk # Firmware analysis
    apktool # Android
    frida-tools # Dynamic instrumentation
    capstone # Disassembly framework
    keystone # Assembly framework
    unicorn # CPU emulator

    # --- Web Security ---
    # burpsuite # Replaced by Burp Suite Professional in home/packages.nix
    zap # OWASP ZAP
    nuclei # Template-based vulnerability scanner
    sqlmap # SQL Injection
    ffuf # Fast web fuzzer
    gobuster # Directory brute-forcing
    wpscan # WordPress Scanner
    nikto
    mitmproxy
    httpie
    curl
    wget
    feroxbuster # Add feroxbuster here
    seclists # Wordlists for fuzzing

    # --- Forensics & Steganography ---
    volatility3 # Memory forensics
    sleuthkit # Disk forensics
    autopsy # GUI for Sleuthkit
    foremost # File carving
    scalpel # Another file carver
    testdisk # Partition recovery & PhotoRec
    dc3dd # Enhanced dd for forensics
    tcpflow # TCP stream reconstruction
    pcapfix # Repair damaged PCAP files
    exiftool # Metadata
    zsteg # PNG/BMP stego
    steghide
    pngcheck
    ffmpeg

    # --- Signal Analysis (SDR) ---
    gqrx # SDR Receiver
    rtl-sdr # RTL-SDR tools
    hackrf # HackRF tools
    inspectrum # Offline signal analysis
    urh # Universal Radio Hacker

    # --- Cryptography & Cracking ---
    john # Password cracker
    hashcat # Advanced password recovery
    thc-hydra # Network login cracker
    cyberchef # The Swiss Army Knife
    xortool # XOR analysis
    fcrackzip

    # --- Network Scanning & Pivoting ---
    nmap
    rustscan # Faster Nmap
    naabu # Fast port scanner (ProjectDiscovery)
    masscan # Mass IP scanner
    wireshark
    tcpdump
    netcat-gnu
    socat
    bettercap # MITM framework
    aircrack-ng # WiFi auditing

    # --- Active Directory & Windows Attacks ---
    kerbrute # Kerberos pre-auth bruteforcing
    evil-winrm # WinRM shell
    samba # smbclient etc.
    cifs-utils # mounting smb
    bloodhound # AD Relations Visualizer (Indispensable AD)
    neo4j # Backend for Bloodhound
    certipy # AD CS Abuse (Certificates)

    # --- C2 & Pivoting (Modern Red Team) ---
    #sliver      # C2 Framework (Go) - The modern standard
    ligolo-ng # Pivoting 2.0 (Tun interfaces, better than chisel)
    chisel # TCP Tunneling (Classic)
    sshuttle # VPN over SSH
    metasploit # Metasploit (C2 + Exploits)
    # spiderfoot        # Automated OSINT collection (The "scanner" approach) (Missing)
    maltego # Link analysis & visualization (The "graph" approach)
    recon-ng # Web Reconnaissance framework (The "Metasploit" approach)
    amass # In-depth DNS enumeration & matching
    maigret

    # --- 7. TARGETED OSINT TOOLS ---
    sherlock # Username search
    # maigret           # Advanced username search (often better than Sherlock) (Dependency pyhanko failed build)
    theharvester # Email/Domain gathering
    python3Packages.shodan # Search engine for devices (CLI)
    ghunt # Google Account OSINT (Extract data from emails/GaiaIDs)
    holehe # Check if email is attached to accounts (without login)
    socialscan # Check email/username availability
    metadata-cleaner # Clean metadata before sharing

    # --- 8. MISC & UTILS ---
    jq # JSON processor
    yara # Pattern matching
    ripgrep # Fast grep
    fd # Fast find
    bat # Cat with wings
    tmux # Terminal multiplexer (essential for multi-tasking)

    # --- Python Environment (Essential libs) ---
    (python3.withPackages (
      ps: with ps; [
        pwntools # CTF framework standard
        pycryptodome # Crypto
        requests
        scapy # Network packet manipulation
        impacket # Network protocols
        z3-solver # Theorem prover

        # AI & Automation
        google-generativeai # Le SDK officiel Gemini
        langchain
        langchain-community
        pandas
        numpy
        scipy # Spatial algorithms & Gamma function (hyperspheres)
        scikit-learn # Manifold learning (Isomap, PCA)
        matplotlib # Visualization
        seaborn # Statistical data visualization

        ipython # Interactive shell
        tqdm
        pillow
        beautifulsoup4
        ropper
        unicorn
        capstone
        keystone-engine
      ]
    ))
  ];

  shellHook = ''
    # Red prompt for "Attack Mode" to clearly distinguish from normal shell
    export PS1="\n[\033[1;31m][🚩 CTF-MODE:\w]\$ [\033[0m] "

    # Setup Seclists Environment
    export SECLISTS="${pkgs.seclists}/share/wordlists/seclists"
    export FEROX_WORDLIST="$SECLISTS/Discovery/Web-Content/raft-medium-directories.txt"

    # Aliases for Bash (fallback)
    alias ls='eza --icons=auto' 
    alias ll='eza -la --icons=auto'
    alias grep='grep --color=auto'

    # Feroxbuster shortcuts
    alias ferox="feroxbuster"
    alias ferox-common="feroxbuster -w $SECLISTS/Discovery/Web-Content/raft-medium-directories.txt"
    alias ferox-full="feroxbuster -w $SECLISTS/Discovery/Web-Content/directory-list-2.3-medium.txt"

    echo "CTF Environment Loaded"
    echo "Tools: Pwn, Reverse, Crypto, Web, OSINT"
    echo "Wordlists: \$SECLISTS"
    echo "Specific Opti: X1 Carbon Gen 12"

    # Launch ZSH if available for full user experience
    if command -v zsh >/dev/null 2>&1;
      then
      export CTF_MODE=1
      exec zsh
    fi
  '';
}
