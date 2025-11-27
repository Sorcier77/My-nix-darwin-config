{ pkgs, ... }:
{
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
    # openssh replaced by programs.ssh package configuration
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
}
