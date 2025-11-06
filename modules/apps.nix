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
      interval = { Weekday = 7; }; # Every Sunday
      options = "--delete-older-than 30d";
    };

    # Optimize nix store
    nix.optimise = {
      automatic = true;
      interval = { Weekday = 7; };
    };

    environment.systemPackages = with pkgs;
    [
      vim
      git
      wget
      curl
      tmux
      htop
      btop
      tree
      nodejs
      openvpn
      zip
      unzip
      p7zip
      # Development tools migrated from brew
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
    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
      taps = [];

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
	"wireshark"
        "zlib"
        "zstd"
        # Utilities
        "awscli"
        "hexedit"
        "rsync"
      ];

      casks = [
        "temurin@11"
        "android-platform-tools"
        "chromedriver"
        "miniconda"
        "xquartz"
        "sublime-text"
        "tomatobar"
      ];
	};
}
