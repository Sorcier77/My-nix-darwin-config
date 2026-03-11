{ pkgs, ... }:
{
    ##########################################################################
    #
    #  Install all apps and packages here.
    ##########################################################################

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;
    environment.variables.EDITOR = "nvim";

    # Nix garbage collection
    nix.gc = {
      automatic = true;
      interval = { Weekday = 0; }; # Every Sunday
      options = "--delete-older-than 14d";
    };

    # Optimize nix store
    nix.optimise = {
      automatic = true;
    };

    environment.systemPackages = with pkgs;
    [
      vim
      git
      gh # GitHub CLI
      jq # JSON processor
      yq-go # YAML processor
      doggo # Modern DNS client
      step-cli # Crypto/PKI tool
      
      # --- INTELLIGENCE & CYBER OPERATIONS (High-End Toolkit) ---
      # 1. OSINT & Attack Surface Mapping
      amass       # In-depth DNS enumeration and network mapping
      subfinder   # Fast passive subdomain discovery
      httpx       # Fast and multi-purpose HTTP toolkit
      nuclei      # Targeted vulnerability scanning
      naabu       # Fast port scanner (Rust)
      
      # 2. Network Intelligence & Traffic Analysis
      tshark      # Terminal-based Wireshark for headless packet analysis
      termshark   # TUI for tshark (clean terminal interface)
      proxychains-ng # Force any TCP connection through Tor or SOCKS
      
      # 3. Forensics & Data Extraction (SIGINT/DOCINT)
      exiftool    # Ultimate metadata extraction (critical for OSINT)
      binwalk     # Firmware & file signature extraction
      ripgrep-all # 'rga': Search through PDFs, E-Books, Office docs, zip, tar.gz
      
      # 4. Modern Crypto & OpSec
      age         # Modern, secure, simple file encryption (replaces GPG for files)
      rage        # Rust implementation of age
      sops        # Secret OPerationS (manage encrypted config files)
      # --------------------------------------------------------

      asciinema #record my terminal
      wget
      curl
      tmux
      btop
      bottom
      caido # burp like
      sliver # C2 framework
      # exegol #cyber tools
      tree
      magic-wormhole
      nodejs
      openvpn
      zip
      unzip
      p7zip
      # Development tools migrated from brew
      go
      cmake
      gcc
      gnupg
      # Media tools
      ffmpeg
      imagemagick
      # Network tools
      nmap
      # Databases
      sqlite
      # Python
      python312
      # Document tools
      typst
      graphviz
      obsidian
      ffuf
      pandoc
      texliveSmall
      fastfetch
      rustscan
      # Ai -assistant tools
      ollama        # Local AI model runner (Highly optimized for Apple Silicon)
      claude-code
      opencode
      fabric-ai
      gemini-cli
      
      # Modern replacements
      atuin         # Magical shell history database (SQLite-backed)
      hexyl         # Modern hex viewer in terminal (Rust)
      fq            # jq for binary formats (pcap, mp4, etc.)
      xh            # Fast, friendly tool for sending HTTP requests (Rust)
      broot         # Advanced tree-view file manager
      sniffglue     # Secure multithreaded packet sniffer (Rust)
      bandwhich     # Terminal bandwidth utilization tool (Rust)
      gping         # Ping with a graph
      
      # Additional Ops Tools
      sops          # Secret OPerationS (Mozilla)
      terraform     # Infrastructure as Code
      ansible       # Configuration management
      obfs4         # Obfuscated proxy for stealth tunneling
      
      # Development & Linting
      golangci-lint
      shellcheck
      python312Packages.pylint
      
      # Hardware & Security tokens
      yubikey-manager # Manage YubiKeys (includes ykman)
      gnupg           # GPG for hardware keys
      
      # Advanced Recon/Forensics
      # stegseek      # World's fastest steganography cracker (Currently broken)
      trivy         # Container and filesystem vulnerability scanner
      
    ];
    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
      taps = [
        "nikitabobko/tap"
      ];

      brews = [
        # Build dependencies (keep in brew for compatibility)
        "assimp"
        "at-spi2-core"
        "atkmm@2.28"
        "autoconf"
        "automake"
        "boost"
        "brotli"
        "cairo"
        "gettext"
        "glib"
        "gnutls"
        "gtk+3"
        "harfbuzz"
        "icu4c@77"
        "jansson"
        "jpeg-turbo"
        "libpng"
        "libtiff"
        "lua"
        "lz4"
        "mpfr"
        "ncurses"
        "oniguruma"
        "openblas"
        "opencv"
        "openssl@3"
        "pango"
        "pcre2"
        "pkgconf"
        "protobuf"
        "qt"
        "zlib"
        "zstd"
        # Utilities
        "hexedit"
        "rsync"
        #test C++ and benchmarking
      #"googletest"
      # "google-benchmark"
      # "zstd"
        # AI assistant tools
      # "gemini-cli"
        "mistral-vibe"
      ];

      casks = [
        "temurin@11"
        "chromedriver"
        "xquartz"
	      "raycast"
        "sublime-text"
        "tomatobar"
	      "wireshark-app"
        "ghostty"
        # Virtualization & Targets (Cyber Ranges)
        "utm"           # Best QEMU/virtualization UI for Apple Silicon
        "orbstack"      # Lightning fast Docker/Linux environment alternative
        # exif cleanup
        "exifcleaner"
        # ai browser
      ];
	};
}
