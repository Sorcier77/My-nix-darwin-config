{ config, pkgs, lib, ... }:
let
  secretsPath = ../secrets.nix;
  secrets = if builtins.pathExists secretsPath
    then import secretsPath
    else {
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

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

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
      };
    };
    
    # Git configuration
    git = {
      enable = true;
      
      settings = {
        user = {
          name = secrets.git.userName;
          email = secrets.git.userEmail;
        };
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

    # direnv for per-project environments
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      dotDir = "${config.xdg.configHome}/zsh";

      shellAliases = {
        # Home Manager / System Updates
        hms = if isDarwin 
              then "darwin-rebuild switch --flake ~/.config/nix-darwin" 
              else "home-manager switch --flake .";
        hmsg = if isDarwin 
               then "darwin-rebuild switch --flake ~/.config/nix-darwin && darwin-rebuild --list-generations"
               else "home-manager switch --flake . && home-manager generations";
        hmdiff = if isDarwin 
                 then "darwin-rebuild --list-generations"
                 else "home-manager generations";
        
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
        
        # Utilities
        ports = if isDarwin then "lsof -iTCP -sTCP:LISTEN -n -P" else "netstat -tulanp";
        myip = "curl -s ifconfig.me";
        weather = "curl wttr.in";
        
        copilot = "npx @github/copilot";
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
        ] ++ lib.optionals isLinux [ "docker" "kubectl" ]
          ++ lib.optionals isDarwin [ "macos" "brew" ];
      };

      plugins = [
        # Powerlevel10k removed from here to control loading manually
        
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

      # Powerlevel10k Instant Prompt (Conditional) and other custom initializations
      initContent = lib.mkBefore ''
        # Powerlevel10k instant prompt
        if [[ -z "$CTF_MODE" ]]; then
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$USER.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$USER.zsh"
          fi
        fi

        # History configuration
        HISTSIZE=50000
        SAVEHIST=50000
        setopt HIST_IGNORE_ALL_DUPS
        setopt HIST_FIND_NO_DUPS
        setopt HIST_SAVE_NO_DUPS
        setopt SHARE_HISTORY

        # Custom keybindings
        bindkey '^[[A' history-search-backward
        bindkey '^[[B' history-search-forward
        
        # Platform-specific keybindings
        ${if isDarwin then ''
          bindkey '^[[H' beginning-of-line
          bindkey '^[[F' end-of-line
        '' else ''
          bindkey '^[OH' beginning-of-line
          bindkey '^[OF' end-of-line
        ''}
        bindkey '^[[3~' delete-char

        # Better completion behavior
        zstyle ':completion:*' menu select
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

        if [[ -n "$CTF_MODE" ]]; then
           echo "🚀 CTF Environment Detected"
           # --- CTF MODE: Simple Red Prompt ---
           function set_ctf_prompt() {
             PROMPT='%F{red}[🚩 CTF-MODE:%~]$ %f'
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
