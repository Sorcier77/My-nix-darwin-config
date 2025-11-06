{ config, pkgs, ... }: 
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
in
{
  home.packages = with pkgs; [
    # Debugging tools
    gef
    gdb
    binutils
    eza
    # CLI utilities
    ripgrep
    fzf
    lazygit
    pylint
    bat
    pay-respects
    
    # Modern CLI tools
    dust        # Better du
    fd          # Better find
    procs       # Better ps
    tokei       # Count lines of code
    delta       # Better git diff
    tealdeer    # tldr pages
    navi        # Interactive cheatsheets
    direnv      # Per-project env
    
    # SSH
    openssh
    # linter nvim

    vimPlugins.vim-clang-format
    rustfmt
    google-java-format

    # copilot 
    github-copilot-cli
  ];

  programs = {
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
        # Home Manager
        hms = "darwin-rebuild switch --flake ~/.config/nix-darwin";
        
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
      '';
    };
  };

  # Copier votre fichier .p10k.zsh
  home.file.".p10k.zsh".source = ./.p10k.zsh;
}
