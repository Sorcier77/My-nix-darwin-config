{
  description = "My nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixvim, ... }:
  let
    inherit (self) outputs;
    configuration = { pkgs, ... }: {
      system.primaryUser = "anselme";

      #sudo with touchID
      security.pam.services.sudo_local.touchIdAuth = true;

      users.users.anselme = {
        name = "anselme";
        home = "/Users/anselme";
        isHidden = false;
        shell = pkgs.zsh;
      };
      
      nix.settings = {
        experimental-features = "nix-command flakes";
        # Binary caches for faster builds
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;

      nixpkgs.hostPlatform = "aarch64-darwin";
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
    };
  in
  {
    darwinConfigurations."MacBook-Pro-de-Anselme" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [
        configuration
        ./modules/apps.nix
        ./modules/system-defaults.nix

        # home manager
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.anselme = import ./home;
          home-manager.extraSpecialArgs = { inherit inputs outputs; };
          
        }
      ];
    };

    # Home Manager configuration for Fedora (Linux x86_64)
    homeConfigurations."orion" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs outputs; };
      modules = [
        ./home
        {
          # Ensure unfree packages are allowed
          nixpkgs.config.allowUnfree = true;
        }
      ];
    };

    devShells.x86_64-linux.ctf = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "gradle-7.6.6"
        ];
      };
    in pkgs.mkShell {
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
        amass             # In-depth DNS enumeration & mapping
        
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
        export PS1="\n\[\033[1;31m\][🚩 CTF-MODE:\w]\$ \[\033[0m\] "
        
        # Aliases for Bash (fallback)
        alias ls='eza --icons=auto' 
        alias ll='eza -la --icons=auto'
        alias grep='grep --color=auto'

        echo "CTF Environment Loaded."
        echo "Tools: Pwn, Reverse, Crypto, Web, OSINT (Spiderfoot, Maltego, Recon-ng, etc.)"

        # Launch ZSH if available for full user experience
        if command -v zsh >/dev/null 2>&1; then
          export CTF_MODE=1
          exec zsh
        fi
      '';
    };
  };
}
