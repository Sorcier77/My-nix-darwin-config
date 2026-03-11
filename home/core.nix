{ config, pkgs, ... }: 
let
  secretsPath = ../secrets.nix;
  secrets = if builtins.pathExists secretsPath 
    then import secretsPath
    else {
      git = {
        userName = "YourGitHubUsername";
        userEmail = "your.email@example.com";
        signingKey = "";
      };
    };
in
{
  home.packages = with pkgs; [
    # Debugging tools
    #gef not working on macos arm
    #gdb
    binutils
    eza
    # CLI utilities
    ripgrep
    fzf
    lazygit
    pylint
    bat
    pay-respects
    
    # Fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    
    # Modern CLI tools
    dust        # Better du
    fd          # Better find
    procs       # Better ps
    tokei       # Count lines of code
    delta       # Better git diff
    tealdeer    # tldr pages
    rage        # Modern replacement for age/GPG
    navi        # Interactive cheatsheets
    direnv      # Per-project env
    
    # SSH
    openssh
    # linter nvim

    vimPlugins.vim-clang-format
    rustfmt
    google-java-format

    # copilot 
    #github-copilot-cli 
    #wireshark
  ];

  programs = {
    # GPG configuration
    gpg.enable = true;

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
      shellWrapperName = "y";
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

    # System monitor (btop)
    btop = {
      enable = true;
      settings = {
        color_theme = "catppuccin_mocha";
        theme_background = false;
        truecolor = true;
        force_tty = false;
        presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
        vim_keys = true;
        rounded_corners = true;
        graph_symbol = "braille";
        shown_boxes = "cpu mem net proc";
        update_ms = 1000;
        proc_sorting = "cpu lazy";
      };
    };

    # Magical shell history (SQLite backed)
    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = false; # OpSec: Keep history purely local
        style = "compact";
        inline_height = 20;
        show_preview = true;
      };
    };

    # SSH configuration
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
        };
        "skynet" = {
          hostname = "skynet.local"; # Remplacez par l'IP ou le domaine réel si nécessaire
          user = "root";             # Ajustez l'utilisateur
          identityFile = "~/.ssh/id_rsa"; # Ou la clé spécifique
          forwardAgent = true;       # Pratique pour rebondir depuis skynet
          extraOptions = {
            "ServerAliveInterval" = "60";
          };
        };
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/github";
        };
        "clef git NTNU secu" = {
          hostname = "git.ntnu.no";
          user = "git";
          identityFile = "~/.ssh/ntnu-security";
        };
      };
    };

    

    # Git configuration
    git = {
      enable = true;
      
      settings = {
        user = {
          name = secrets.git.userName;
          email = secrets.git.userEmail;
          signingkey = secrets.git.signingKey;
        };
        commit = {
          gpgsign = if secrets.git.signingKey != "" then true else false;
        };
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = false;
        };
        push = {
          default = "simple";
          autoSetupRemote = true;
        };
        core = {
          editor = "nvim";
        };
      };
    };

    # delta for git 
    delta = {
       enable = true;
       enableGitIntegration = true;
    };

    # direnv for per-project environments
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      # Quiet mode for direnv
      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      dotDir = "${config.xdg.configHome}/zsh";

      shellAliases = {
        # Home Manager
        hms = "darwin-rebuild switch --flake ~/.config/nix-darwin";
        hmsg = "darwin-rebuild switch --flake ~/.config/nix-darwin && darwin-rebuild --list-generations";
        hmdiff = "darwin-rebuild --list-generations";
        
        # Git & Development
        lg = "lazygit";
        v = "nvim";
        
        # System (Turbo Mode)
        c = "clear";
        cat = "bat";
        fk = "fuck";
        
        # Modern replacements
        ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
        cd = "z";
        find = "fd";
        du = "dust";
        ps = "procs";
        
        # Search & Help
        s = "web_search duckduckgo";
        tldr = "tldr";
        
        # --- INTELLIGENCE / OPSEC ALIASES ---
        # Search through EVERYTHING (PDFs, docs, zips)
        grep-all = "rga";
        # Secure, proxy-routed network tools (Requires configuring proxychains.conf)
        px = "proxychains4 -q";
        # Fast metadata strip (OpSec)
        strip-meta = "exiftool -all= --keep=Orientation";
        # Quick ports check
        open-ports = "sudo lsof -i -P -n | grep LISTEN";
        
        # --- IA LOCAL (NSA/CYBER MODELS) ---
        ai = "ollama run";
        ai-list = "ollama list";
        # Codestral (Mistral 22B): Best for Code & Vulnerability Research
        codestral = "ollama run codestral";
        # DeepSeek Coder V2 (Lite): Logical reasoning and RE
        deepseek = "ollama run deepseek-coder-v2:lite";
        # Nemo (12B): NVIDIA+Mistral for massive context (128k)
        nemo = "ollama run mistral-nemo";
        
        # --- WORKSPACE MANAGEMENT ---
        workspace = "cd ~/ops";
        
        # Nix cleanup
        clean = "nix-collect-garbage -d && nix-store --gc && nix-store --optimise";
      };

      oh-my-zsh = {
        enable = true;
        extraConfig = builtins.readFile ./extraConfig.zsh;
        plugins = [
          "git"
          "web-search"
          "copyfile"
          "copybuffer"
          "fzf"
          "sudo"
          "history-substring-search" # Search only matching history
        ];
        theme = "powerlevel10k/powerlevel10k";
        custom = "$HOME/.oh-my-zsh/custom";
      };

      plugins = [
        # Powerlevel10k theme - HASH MIS À JOUR
        {
          name = "powerlevel10k";
          src = pkgs.fetchFromGitHub {
            owner = "romkatv";
            repo = "powerlevel10k";
            rev = "v1.20.0";
            hash = "sha256-ES5vJXHjAKw/VHjWs8Au/3R+/aotSbY7PWnWAMzCR8E=";
          };
          file = "powerlevel10k.zsh-theme";
        }
        # Autocompletions
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.1";
            hash = "sha256-vpTyYq9ZgfgdDsWzjxVAE7FZH4MALMNZIFyEOBLm5Qo=";
          };
        }
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
        # Highlight commands in terminal
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.8.0";
            hash = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
          };
        }
      ];

      # Startup configuration
      initContent = ''
        # Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        # Load Powerlevel10k configuration
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        
        # Custom keybindings
        bindkey '^[[A' history-search-backward
        bindkey '^[[B' history-search-forward
        
        # DIRENV SILENCE (Custom)
        export DIRENV_LOG_FORMAT=""
      '';
    };
  };

  # Copier votre fichier .p10k.zsh
  home.file.".p10k.zsh".source = ./.p10k.zsh;
}
