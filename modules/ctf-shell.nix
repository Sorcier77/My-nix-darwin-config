{
  pkgs ? import <nixpkgs> { },
  stable ? pkgs,
}:

let
  # Définition locale de PyMeta (non présent dans nixpkgs)
  pymeta = pkgs.python3Packages.buildPythonApplication rec {
    pname = "pymeta";
    version = "1.1.1";
    pyproject = false; # Utilise setup.py
    src = pkgs.fetchPypi {
      pname = "pymetasec";
      inherit version;
      sha256 = "sha256-lpUkGJnYbZ7noKWpNZAXi1FwUJuBLRaxwvQJdL0DWzk=";
    };
    propagatedBuildInputs = with pkgs.python3Packages; [
      requests
      beautifulsoup4
      pkgs.exiftool
    ];
    doCheck = false;
  };
in
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
    nasm # Assembler for shellcode crafting
    qemu # Emulation for cross-arch exploit dev

    # --- Reverse Engineering ---
    stable.jadx # Decompiler
    android-tools # adb, fastboot
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
    caido # Modern Web Proxy
    zap # OWASP ZAP
    nuclei # Template-based vulnerability scanner
    subfinder # Subdomain discovery
    httpx # Fast HTTP toolkit
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

    # --- Intelligence & Advanced Recon ---
    sn0int # Semi-automatic OSINT framework
    katana # Next-generation crawler (Go)
    gau # Get All URLs (Go)
    waybackurls # Wayback machine discovery (Go)
    metabigor # Search engine intelligence
    cloudfox # Cloud infrastructure recon
    cloudbrute # Cloud resource brute-forcing
    stable.theharvester # BROKEN ON UNSTABLE (psycopg build failure)
    amass # In-depth DNS enumeration & matching
    sherlock # Username search
    # maigret # BROKEN ON UNSTABLE (timing tests failure)
    ghunt # Google account intelligence
    holehe # Email registration check
    socialscan # Social media check
    python3Packages.shodan # Shodan CLI
    recon-ng # OSINT framework (Metasploit style)
    maltego # Link analysis & visualization
    metadata-cleaner # Clean metadata
    exiftool # File metadata analysis

    # --- Forensics & Steganography ---
    volatility3 # Memory forensics
    sleuthkit # Disk forensics
    autopsy # GUI for Sleuthkit
    foremost # File carving
    scalpel # Another file carver
    testdisk # Partition recovery & PhotoRec
    # dc3dd # BROKEN ON UNSTABLE (compile error)
    tcpflow # TCP stream reconstruction
    pcapfix # Repair damaged PCAP files
    exiftool # Metadata
    pymeta # Document metadata discovery & extraction (PyMeta rewrite)
    zsteg # PNG/BMP stego
    steghide
    pngcheck
    ffmpeg

    # --- Signal Analysis (SIGINT/SDR) ---
    gnuradio # The standard for signal processing
    # gqrx # BROKEN ON UNSTABLE (boost/gr-osmosdr error)
    rtl-sdr # RTL-SDR tools
    hackrf # HackRF tools
    inspectrum # Offline signal analysis
    urh # Universal Radio Hacker
    kismet # Wireless network sniffer & monitor (Essential SIGINT)

    # --- Stealth, Anonymity & P2P (High-Security) ---
    i2pd # C++ implementation of I2P (Lightweight & Fast)
    zeronet-conservancy # P2P decentralized network
    tor # Tor CLI
    proxychains-ng # Traffic redirection

    # --- Network Scanning & Pivoting ---
    nmap
    rustscan # Faster Nmap
    naabu # Fast port scanner (ProjectDiscovery)
    masscan # Mass IP scanner
    wireshark-cli # tshark & CLI Wireshark
    tcpdump
    netcat-gnu
    socat
    bettercap # MITM framework
    aircrack-ng # WiFi auditing
    responder # LLMNR/NBT-NS/mDNS Poisoner (Essential AD)
    bore # Modern tunneling
    jwt-cli # JWT Manipulation Tool

    # --- Active Directory & Windows Attacks ---
    netexec # Modern successor to CrackMapExec
    bloodhound-py # Python Ingestor
    bloodhound-ce # Modern BloodHound (Community Edition)
    kerbrute # Kerberos pre-auth bruteforcing
    evil-winrm # WinRM shell
    samba # smbclient etc.
    cifs-utils # mounting smb
    bloodhound # AD Relations Visualizer (Classic)
    neo4j # Backend for Bloodhound
    certipy # AD CS Abuse (Certificates)

    # --- C2 & Pivoting (Modern Red Team) ---
    havoc # Modern C2 framework (Golang/C++)
    #sliver      # C2 Framework (Go) - The modern standard
    ligolo-ng # Pivoting 2.0 (Tun interfaces, better than chisel)
    chisel # TCP Tunneling (Classic)
    sshuttle # VPN over SSH
    metasploit # Metasploit (C2 + Exploits)
    gitleaks # Secrets scanning
    trufflehog # Secrets scanning
    # prowler # BROKEN ON UNSTABLE (azure-mgmt-network build failure)
    osv-scanner # OSV Vulnerability Scanner

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

        # AI, Data Analysis & Platform Building
        google-generativeai # Le SDK officiel Gemini
        # langchain # BROKEN ON UNSTABLE (psycopg build failure)
        # langchain-community
        pandas
        polars # Fast DataFrame library for large datasets
        numpy
        scipy # Spatial algorithms & Gamma function (hyperspheres)
        scikit-learn # Manifold learning (Isomap, PCA)
        matplotlib # Visualization
        seaborn # Statistical data visualization
        jupyterlab # Notebook environment for analysts
        fastapi # For building internal tools/platforms
        uvicorn # ASGI server for FastAPI
        flask # Microframework for quick platforms

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
