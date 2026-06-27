{
  config,
  pkgs,
  lib,
  ...
}:
let
  # secretsPath = ../secrets.nix;
  # secrets =
  #   if builtins.pathExists secretsPath then
  #     import secretsPath
  #   else
  #     {
  #       git = {
  #         userName = "Sorcier77";
  #         userEmail = "ag.anselmegarnier@gmail.com";
  #       };
  #     };
in
{
  # SOPS Configuration for Home Manager
  sops.secrets = {
    "git/name" = { };
    "git/email" = { };
  };

  # Template pour générer un fichier de config Git propre à partir des secrets
  sops.templates."git-config".content = ''
    [user]
      name = "${config.sops.placeholder."git/name"}"
      email = "${config.sops.placeholder."git/email"}"
  '';

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

    # Foot Terminal Emulator (Disabled - too minimalist)
    foot = {
      enable = false;
      settings = {
        main = {
          font = "JetBrainsMono NFM:size=10";
        };
        # ... (rest of foot settings)
      };
    };

    # Kitty Terminal Emulator (GPU Accelerated & Fast)
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono NFM";
        size = 10;
      };
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
        update_check_interval = 0;
        confirm_os_window_close = 0;
        
        # Layouts
        enabled_layouts = "splits,stack";

        # Performance settings
        repaint_delay = 10;
        input_delay = 3;
        sync_to_monitor = "yes";

        # Appearance
        background_opacity = "0.95";
        window_padding_width = 4;
        
        # Colors (Catppuccin Frappe)
        foreground = "#c6d0f5";
        background = "#303446";
        selection_foreground = "#303446";
        selection_background = "#f2d5cf";
        url_color = "#f2d5cf";
        cursor = "#f2d5cf";
        cursor_text_color = "#303446";
        active_border_color = "#babed8";
        inactive_border_color = "#737994";
        bell_border_color = "#e5c890";
        wayland_titlebar_color = "system";
        macos_titlebar_color = "system";
        active_tab_foreground = "#232634";
        active_tab_background = "#ca9ee6";
        inactive_tab_foreground = "#c6d0f5";
        inactive_tab_background = "#292c3c";
        tab_bar_background = "#232634";
        color0 = "#51576d";
        color8 = "#626880";
        color1 = "#e78284";
        color9 = "#e78284";
        color2 = "#a6d189";
        color10 = "#a6d189";
        color3 = "#e5c890";
        color11 = "#e5c890";
        color4 = "#8caaee";
        color12 = "#8caaee";
        color5 = "#f4b8e4";
        color13 = "#f4b8e4";
        color6 = "#81c8be";
        color14 = "#81c8be";
        color7 = "#b5bfe2";
        color15 = "#a5adce";
      };
      keybindings = {
        # Splits/Panes
        "alt+enter" = "launch --location=vsplit --cwd=current";
        "alt+shift+enter" = "launch --location=hsplit --cwd=current";
        "alt+w" = "close_window";

        # Navigate splits with Vim-like keys or arrow keys
        "alt+h" = "neighboring_window left";
        "alt+l" = "neighboring_window right";
        "alt+k" = "neighboring_window up";
        "alt+j" = "neighboring_window down";
        "alt+left" = "neighboring_window left";
        "alt+right" = "neighboring_window right";
        "alt+up" = "neighboring_window up";
        "alt+down" = "neighboring_window down";

        # Resize splits
        "ctrl+alt+h" = "resize_window narrower";
        "ctrl+alt+l" = "resize_window wider";
        "ctrl+alt+k" = "resize_window taller";
        "ctrl+alt+j" = "resize_window shorter";

        # Zoom/Maximize pane (like tmux's toggle-zoom)
        "alt+z" = "toggle_layout stack";

        # Tabs
        "alt+t" = "new_tab_with_cwd";
        "alt+shift+l" = "next_tab";
        "alt+shift+h" = "previous_tab";
        "alt+1" = "goto_tab 1";
        "alt+2" = "goto_tab 2";
        "alt+3" = "goto_tab 3";
        "alt+4" = "goto_tab 4";
        "alt+5" = "goto_tab 5";
        "alt+6" = "goto_tab 6";
        "alt+7" = "goto_tab 7";
        "alt+8" = "goto_tab 8";
        "alt+9" = "goto_tab 9";
      };
    };

    # Alacritty Terminal Emulator

    # --- Firefox Hardened & Optimized (Cyber Standard) ---
    firefox = {
      enable = true;
      package = pkgs.firefox;
      policies = {
        ExtensionSettings = {
          # uBlock Origin
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Bitwarden
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
        };
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        }; # <-- Restored
        # DisablePocket = true;
        DisableFirefoxAccounts = false; # Gardé pour Sync, mettre true pour full local
        # DisableAccounts = false;
        # DisableFirefoxScreenshots = true;
        # OverrideFirstRunPage = "";
        # OverridePostUpdatePage = "";
        # DontCheckDefaultBrowser = true;
        # DisplayBookmarksToolbar = "never"; # Minimalist
        # DisplayMenuBar = "default-off";
        # SearchBar = "unified";
        # # Security
        # HttpsOnlyMode = "force_enabled";
        # DNSOverHTTPS = {
        #   Enabled = true;
        #   ProviderURL = "https://dns.quad9.net/dns-query"; # Quad9 (Security focused)
        #   Locked = true;
        # };
      }; # <-- Restored

      # Hardening avancé (about:config) & Performance Fixes
      profiles.default.settings = {
        "privacy.resistFingerprinting" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "dom.security.https_only_mode" = true;
        "network.auth.subresource-http-auth-allow" = 1;
        "security.ssl.require_safe_negotiation" = true;
        "security.tls.version.min" = 3; # Force TLS 1.3
        
        # --- Performance / Hardware Acceleration (Wayland) ---
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "media.av1.enabled" = false; # Peut ralentir si pas d'accélération matérielle native AV1
        "widget.wayland.opaque-region.enabled" = true;
      };
    }; # Modern cat replacement with syntax highlighting
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
      shellWrapperName = "y";
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

      settings = {
        "*" = {
          # Global SSH Settings (Hardened)
          AddKeysToAgent = "1h";
          VisualHostKey = "yes";
          Compression = "yes";
          ServerAliveInterval = 60;
          ServerAliveCountMax = 3;
          ForwardAgent = "no";
          ForwardX11 = "no";
          ForwardX11Trusted = "no";
          HashKnownHosts = "yes";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/sockets/%r@%h-%p";
          ControlPersist = "600";
          
          # Security: Hardened Ciphers & MACs
          Ciphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr";
          KexAlgorithms = "curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256";
          MACs = "hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha2-256,hmac-sha2-512";
        };

        "github.com" = {
          Hostname = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/github";
        };
        "skynet" = {
          Hostname = "skynet";
          User = "orion";
          IdentityFile = "~/.ssh/github";
        };
        "skynet-1" = {
          Hostname = "skynet-1";
          User = "orion";
          IdentityFile = "~/.ssh/ed25519";
          ForwardX11 = "yes";
          ForwardX11Trusted = "yes";
          SetEnv = { TERM = "xterm-256color"; };
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
      # Includes from SOPS template if it exists
      includes = [
        { path = config.sops.templates."git-config".path; }
      ];

      settings = {
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
        # Git & Development
        lg = "lazygit";
        v = "nvim";
        g = "git";

        # Terminal Multiplexing (Zellij)
        zj = "zellij";
        zja = "zellij attach -c";

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
        nix-audit = "nix-store --verify --check-contents --verify-mode=all";

        # Hardening
        fedora-harden = "sudo bash ${config.home.homeDirectory}/Documents/My-nix-darwin-config/home/fedora-hardening.sh";

        # CTF / Dev
        ctf = "nix develop ${config.home.homeDirectory}/Documents/My-nix-darwin-config#ctf";

        # Utilities
        myip = "curl -s ifconfig.me";
        weather = "curl wttr.in";

        # Hardware & Performance
        gpu-top = "sudo intel_gpu_top";
        va-check = "vainfo";
        perf-check = "sudo powertop";
        nvtop = "nvtop";

        # Security
        bsp = "burpsuitepro > /dev/null 2>&1 &"; # Launch Burp Suite Professional silently
        av-scan = "bash ${config.home.homeDirectory}/Documents/My-nix-darwin-config/home/av-scan.sh";
        yara-scan = "bash ${config.home.homeDirectory}/Documents/My-nix-darwin-config/home/yara-scan.sh";
        torexec = "proxychains4"; # Execute command through Tor
        tor-start = "tor > /dev/null 2>&1 & echo 'Tor started in background...'";
        tor-stop = "killall tor";
        
        # System Audit & Hardening
        audit-system = "sudo lynis audit system";
        check-vuln = "nix run nixpkgs#vulnix -- --system";
        check-sec = "sudo bash ${config.home.homeDirectory}/Documents/My-nix-darwin-config/home/fedora-hardening.sh";

        secrets = "sops ${config.home.homeDirectory}/Documents/My-nix-darwin-config/secrets.yaml";
        wipe = "srm -v"; # Suppression sécurisée avec verbeux

        genpass = "tr -dc 'A-Za-z0-9!@#$%^&*' < /dev/urandom | head -c 32; echo"; # Génère mdp fort 32 chars

        copilot = "npx @github/copilot";
      };

      oh-my-zsh = {
        enable = true;
        extraConfig = builtins.readFile ./extraConfig.zsh;
        plugins = [
          "git"
          "sudo"
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
      initContent = lib.mkBefore ''
        # Force local bin in PATH (for agy and other local tools)
        export PATH="$HOME/.local/bin:$PATH"

        # Powerlevel10k instant prompt
        if [[ -z "$CTF_MODE" ]]; then
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$USER.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$USER.zsh"
          fi
        fi

        # Security: Harden file permissions (Lynis recommendation)
        umask 077 # Drastique : RW pour moi, Rien pour les autres.

        # Security: Disable Core Dumps (Empêche la fuite de secrets RAM vers Disque)
        ulimit -c 0

        # History configuration
        HISTSIZE=50000
        SAVEHIST=50000
        setopt HIST_IGNORE_ALL_DUPS
        setopt HIST_FIND_NO_DUPS
        setopt HIST_SAVE_NO_DUPS
        setopt HIST_IGNORE_SPACE # Espace au début = Pas d'historique (OpSec)
        setopt SHARE_HISTORY

        # Custom keybindings
        bindkey '^[[A' history-search-backward
        bindkey '^[[B' history-search-forward

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
