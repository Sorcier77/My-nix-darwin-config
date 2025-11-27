{ config, pkgs, lib, ... }:
let
  secretsPath = ../secrets.nix;
  secrets = if builtins.pathExists secretsPath
    then import secretsPath
    else {
      git = {
        userName = "YourGitHubUsername";
        userEmail = "your.email@example.com";
      };
    };
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  # Restore the Powerlevel10k configuration file
  home.file.".p10k.zsh".source = ./.p10k.zsh;

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
      package = pkgs.openssh_gssapi;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
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
        
        # System
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
        
        # Nix cleanup
        clean = "nix-collect-garbage -d && nix-store --gc && nix-store --optimise";
        
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
        ];
        # Theme managed manually in initExtra to allow conditional loading
        # theme = "powerlevel10k/powerlevel10k"; 
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

      # Powerlevel10k Instant Prompt (Conditional)
      initExtraFirst = ''
        if [[ -z "$CTF_MODE" ]]; then
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        fi
      '';

      initExtra = ''
        # Custom keybindings
        bindkey '^[[A' history-search-backward
        bindkey '^[[B' history-search-forward

        if [[ -n "$CTF_MODE" ]]; then
           # --- CTF MODE: Simple Red Prompt ---
           PROMPT='%F{red}[🚩 CTF-MODE:%~]$ %f'
        else
           # --- NORMAL MODE: Load Powerlevel10k ---
           source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
           [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        fi
      '';
    };
  };
}
