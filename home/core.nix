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
in{
  # Allow unfree packages (useful for standalone home-manager on Linux)
  nixpkgs.config.allowUnfree = true;

  # Better integration for non-NixOS Linux (handles XDG_DATA_DIRS, fonts, etc.)
  targets.genericLinux.enable = isLinux;

  fonts.fontconfig.enable = true;

  home.activation.installNerdFonts = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Linking Nerd Fonts to ~/.local/share/fonts..."
    mkdir -p $HOME/.local/share/fonts
    find $HOME/.nix-profile/share/fonts -name "*NerdFont*.ttf" -exec ln -sf {} $HOME/.local/share/fonts/ \;
    echo "Updating font cache..."
    ${pkgs.fontconfig}/bin/fc-cache -f $HOME/.local/share/fonts
  '';

  home.packages = with pkgs; [
    # Fonts configuration
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    
    # Debugging tools
    gef
    gdb
    binutils
    # CLI utilities
    ripgrep
    fzf
    lazygit
    pylint
    pay-respects
    
    # Modern CLI tools
    dust        # Better du
    fd          # Better find
    procs       # Better ps
    tokei       # Count lines of code
    tealdeer    # tldr pages
    navi        # Interactive cheatsheets
    
    # SSH
    openssh
    # linter nvim

    vimPlugins.vim-clang-format
    rustfmt
    google-java-format

    # copilot 
    github-copilot-cli
    #wireshark

    # ----------------------------------------------------------------
    # Packages migrated from modules/apps.nix for cross-platform support
    # ----------------------------------------------------------------
    vim
    wget
    curl
    htop
    btop
    tree
    nodejs
    openvpn
    zip
    unzip
    p7zip
    # Development tools
    go
    cmake
    gcc
    llvm
    # Media tools
    ffmpeg
    imagemagick
    # Network tools
    nmap
    # Databases
    mysql84
    sqlite
    # Python
    python312
    # Document tools
    typst
    graphviz
    obsidian
    pandoc
    texliveSmall
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

      # Startup configuration (Modernized)
      # Using lib.mkBefore ensures this runs first (for Instant Prompt)
      initContent = lib.mkMerge [
        (lib.mkBefore ''
          # Powerlevel10k instant prompt
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        '')
        (lib.mkAfter ''
          # Load Powerlevel10k configuration
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
          
          # Custom keybindings
          bindkey '^[[A' history-search-backward
          bindkey '^[[B' history-search-forward
        '')
      ];
    };
  };

  # Copier votre fichier .p10k.zsh
  home.file.".p10k.zsh".source = ./.p10k.zsh;
}
