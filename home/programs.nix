{
  config,
  pkgs,
  lib,
  ...
}:
let
  secretsPath = ../secrets.nix;
  secrets =
    if builtins.pathExists secretsPath then
      import secretsPath
    else
      {
        git = {
          userName = "Sorcier77";
          userEmail = "ag.anselmegarnier@gmail.com";
        };
      };
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  # Restore the Powerlevel10k configuration file
  home.file.".p10k.zsh".source = ./.p10k.zsh;

  # Create SSH sockets directory for connection multiplexing
  home.file.".ssh/sockets/.keep".text = "";

  # Proxychains configuration for Tor
  home.file.".proxychains/proxychains.conf".text = ''
    strict_chain
    proxy_dns
    remote_dns_subnet 224
    tcp_read_time_out 15000
    tcp_connect_time_out 8000
    [ProxyList]
    socks5  127.0.0.1 9050
  '';

  # Feroxbuster Configuration
  home.file.".config/feroxbuster/ferox-config.toml".text = ''
    wordlist = "${pkgs.seclists}/share/wordlists/seclists/Discovery/Web-Content/raft-medium-directories.txt"
  '';

    services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    # enableSshSupport = true; # Désactivé pour permettre l'utilisation de clés SSH basées sur fichiers
    pinentry.package = pkgs.pinentry-gnome3;
    defaultCacheTtl = 600;
    maxCacheTtl = 7200;
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # Foot Terminal Emulator
    foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono NFM:size=10";

          # You can add more foot specific settings here if desired.
          # For example, colors, keybindings, etc.
          # Refer to the foot documentation or the web search result for more options.
        };
      };

    };

    # Alacritty Terminal Emulator
    
    # --- Firefox Hardened (Cyber Standard) ---
    # Disabled by user request to use system Firefox (faster on Fedora)
    firefox = {
      enable = false;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
      #   };
      #   DisablePocket = true;
        DisableFirefoxAccounts = false; # Gardé pour Sync, mettre true pour full local
      #   DisableAccounts = false;
      #   DisableFirefoxScreenshots = true;
      #   OverrideFirstRunPage = "";
      #   OverridePostUpdatePage = "";
      #   DontCheckDefaultBrowser = true;
      #   DisplayBookmarksToolbar = "never"; # Minimalist
      #   DisplayMenuBar = "default-off";
      #   SearchBar = "unified";
      #   # Security
      #   HttpsOnlyMode = "force_enabled";
      #   DNSOverHTTPS = {
      #     Enabled = true;
      #     ProviderURL = "https://dns.quad9.net/dns-query"; # Quad9 (Security focused)
      #     Locked = true;
      #   };
      # };
      
      # # Hardening avancé (about:config)
      # profiles.default.settings = {
      #   "privacy.resistFingerprinting" = true; # 🛡️ Tor Browser anti-fingerprinting (Timezone UTC, etc.)
      #   "privacy.fingerprintingProtection" = true;
      #   "privacy.trackingprotection.fingerprinting.enabled" = true;
      #   "privacy.trackingprotection.cryptomining.enabled" = true;
      #   "dom.security.https_only_mode" = true;
      #   "network.auth.subresource-http-auth-allow" = 1;
      #   "security.ssl.require_safe_negotiation" = true;
      #   "security.tls.version.min" = 3; # Force TLS 1.3 (peut casser de vieux sites)
      # };
    };

    # Modern cat replacement with syntax highlighting
    bat = {
      enable = true;
      config = {
        theme = "Catppuccin Frappe";
        style = "numbers,changes,header";
      };
    };

    # A modern replacement for 'ls'
    eza = {
      enable = true;
      git = true;
      icons = "auto";
      enableZshIntegration = true;
    };

    # terminal file manager
    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
          sort_dir_first = true;
        };
      };
    };

    # Smart directory jumper
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # SSH configuration
    ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          # Essential defaults
          addKeysToAgent = "yes";
          compression = true;
          serverAliveInterval = 60;
          serverAliveCountMax = 3;

                              # Security defaults

                              forwardAgent = false;

                              forwardX11 = false;

                              forwardX11Trusted = false;

                              hashKnownHosts = true; # 🛡️ Hache les IP/Noms des serveurs (Anti-Forensics)

                              

                              # Hardened Ciphers & MACs (Cyber Standard)
                              extraOptions = {
                                VisualHostKey = "yes";
                                Ciphers = builtins.concatStringsSep "," [
                                  "chacha20-poly1305@openssh.com"
                                  "aes256-gcm@openssh.com"
                                  "aes128-gcm@openssh.com"
                                  "aes256-ctr"
                                  "aes192-ctr"
                                  "aes128-ctr"
                                ];
                                KexAlgorithms = builtins.concatStringsSep "," [
                                  "curve25519-sha256"
                                  "curve25519-sha256@libssh.org"
                                  "diffie-hellman-group16-sha512"
                                  "diffie-hellman-group18-sha512"
                                  "diffie-hellman-group-exchange-sha256"
                                ];
                                MACs = builtins.concatStringsSep "," [
                                  "hmac-sha2-256-etm@openssh.com"
                                  "hmac-sha2-512-etm@openssh.com"
                                  "hmac-sha2-256"
                                  "hmac-sha2-512"
                                ];
                              };

          # Connection defaults
          controlMaster = "auto";
          controlPath = "~/.ssh/sockets/%r@%h-%p";
          controlPersist = "600";
        };

        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/github";
        };
        "skynet" = {
          hostname = "skynet";
          user = "orion";
          identityFile = "~/.ssh/github";
        };
      };
    };

    # GPG Configuration
    gpg = {
      enable = true;
      settings = {
        # Hardening GPG
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        charset = "utf-8";
        fixed-list-mode = true;
        no-comments = true;
        no-emit-version = true;
        no-greeting = true;
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = true;
        require-cross-certification = true;
        no-symkey-cache = true;
        use-agent = true;
        throw-keyids = true;
      };
    };

    # Git configuration
    git = {
      enable = true;

      settings = {
        user = {
          name = secrets.git.userName;
          email = secrets.git.userEmail;
          # signingkey = null; # Removed: null is not valid. GPG defaults will be used.
        };
        commit.gpgsign = true; # OBLIGATOIRE : Tout commit doit être signé
        tag.gpgsign = true;
        
        init.defaultBranch = "main";
        pull.rebase = false;
        push = {
          default = "simple";
          autoSetupRemote = true;
        };
        core = {
          editor = "nvim";
          # Performance improvements
          preloadindex = true;
          fscache = true;
        };
        gc.auto = 256;
        # Better diff algorithm
        diff.algorithm = "histogram";
        # Reuse recorded resolutions
        rerere.enabled = true;

        # Git aliases
        alias = {
          st = "status -sb";
          co = "checkout";
          br = "branch";
          ci = "commit";
          unstage = "reset HEAD --";
          last = "log -1 HEAD";
          visual = "log --graph --oneline --decorate --all";
          amend = "commit --amend --no-edit";
        };
      };
    };

    # delta for git
    delta = {
      enable = true;
      enableGitIntegration = true;
    };

    # Fuzzy Finder
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # direnv for per-project environments
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    # nix-index for command-not-found functionality
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    # Modern Terminal Emulator (GPU Accelerated)
    # Disabled to use system kitty (better OpenGL support on Fedora)
    # Configuration is managed manually below via xdg.configFile to ensure consistency
      zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      dotDir = "${config.xdg.configHome}/zsh";

      shellAliases = {
        # Home Manager / System Updates
        hms =
          if isDarwin then
            "darwin-rebuild switch --flake ~/.config/nix-darwin"
          else
            "home-manager switch --flake .";
        hmsg =
          if isDarwin then
            "darwin-rebuild switch --flake ~/.config/nix-darwin && darwin-rebuild --list-generations"
          else
            "home-manager switch --flake . && home-manager generations";
        hmdiff = if isDarwin then "darwin-rebuild --list-generations" else "home-manager generations";

        # Git & Development
        lg = "lazygit";
        v = "nvim";
        g = "git";

        # System
        c = "clear";
        cat = "bat";
        fk = "fuck";

        # Modern replacements
        ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
        ll = "eza -lah --git --icons";
        la = "eza -a --icons";
        lt = "eza --tree --level=2 --icons";
        cd = "z";
        find = "fd";
        du = "dust";
        ps = "procs";
        grep = "rg";

        # Search & Help
        s = "web_search duckduckgo";
        tldr = "tldr";

        # Nix cleanup
        clean = "nix-collect-garbage -d && nix-store --gc && nix-store --optimise";

        # Sudo Nix wrapper
        sudonix = "sudo env \"PATH=$PATH\"";

        # Hardening
        fedora-harden = "sudo bash ${config.home.homeDirectory}/Documents/My-nix-darwin-config/home/fedora-hardening.sh";

        # CTF / Dev
        ctf = "nix develop ${config.home.homeDirectory}/Documents/My-nix-darwin-config#ctf";

        # Utilities
        ports = if isDarwin then "lsof -iTCP -sTCP:LISTEN -n -P" else "netstat -tulanp";
        myip = "curl -s ifconfig.me";
        weather = "curl wttr.in";

        # Security
        bsp = "burpsuitepro > /dev/null 2>&1 &"; # Launch Burp Suite Professional silently
        av-scan = "bash ${config.home.homeDirectory}/Documents/My-nix-darwin-config/home/av-scan.sh";
        yara-scan = "bash ${config.home.homeDirectory}/Documents/My-nix-darwin-config/home/yara-scan.sh";
        torexec = "proxychains4"; # Execute command through Tor
        tor-start = "tor > /dev/null 2>&1 & echo 'Tor started in background...'";
        tor-stop = "killall tor";

        
        netwatch = if isDarwin 
          then "watch -n 1 'lsof -i | grep ESTABLISHED'" 
          else "watch -n 1 'ss -tupna | grep ESTAB'";
          
        wipe = "srm -r"; # Suppression sécurisée

        # OpSec Clipboard & Utils
        clippurge = if isDarwin
          then "pbcopy < /dev/null"
          else "xsel -bc && xsel -c";
          
        clip-secret = if isDarwin
          then "cat $1 | pbcopy"
          else "cat $1 | xsel -ib"; # Usage: clip-secret id_rsa
          
        genpass = "tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c 32; echo"; # Génère mdp fort 32 chars

        copilot = "npx @github/copilot";
      };

      oh-my-zsh = {
        enable = true;
        extraConfig = builtins.readFile ./extraConfig.zsh;
        plugins = [
          "git"
          "sudo"
        ]
        ++ lib.optionals isDarwin [
          "macos"
          "brew"
        ];
      };

      plugins = [
        # Powerlevel10k removed from here to control loading manually

        # Completion scroll
        {
          name = "zsh-completions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-completions";
            rev = "0.35.0";
            hash = "sha256-GFHlZjIHUWwyeVoCpszgn4AmLPSSE8UVNfRmisnhkpg=";
          };
        }
      ];

      # Zsh initialization
      initExtra = lib.mkBefore ''
        # Powerlevel10k instant prompt
        if [[ -z "$CTF_MODE" ]]; then
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$USER.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$USER.zsh"
          fi
        fi

        # Security: Harden file permissions (Lynis recommendation)
        umask 077 # 🔒 Drastique : RW pour moi, Rien pour les autres.

        # Security: Disable Core Dumps (Empêche la fuite de secrets RAM vers Disque)
        ulimit -c 0

        # History configuration
        HISTSIZE=50000
        SAVEHIST=50000
        setopt HIST_IGNORE_ALL_DUPS
        setopt HIST_FIND_NO_DUPS
        setopt HIST_SAVE_NO_DUPS
        setopt HIST_IGNORE_SPACE # 🚀 Espace au début = Pas d'historique (OpSec)
        setopt SHARE_HISTORY

        # Custom keybindings
        bindkey '^[[A' history-search-backward
        bindkey '^[[B' history-search-forward

        # Platform-specific keybindings
        ${
          if isDarwin then
            ''
              bindkey '^[[H' beginning-of-line
              bindkey '^[[F' end-of-line
            ''
          else
            ''
              bindkey '^[OH' beginning-of-line
              bindkey '^[OF' end-of-line
            ''
        }
        bindkey '^[[3~' delete-char

        # Better completion behavior
        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

        if [[ -n "$CTF_MODE" ]]; then
           echo "CTF Environment Detected"
           # --- CTF MODE: Simple Red Prompt ---
           function set_ctf_prompt() {
             PROMPT='%F{red}[CTF-MODE:%~]$ %f'
             RPROMPT=""
           }
           precmd_functions+=(set_ctf_prompt)
           set_ctf_prompt
        else
           # --- NORMAL MODE: Load Powerlevel10k ---
           source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
           [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        fi
      '';
    };
  };
}
