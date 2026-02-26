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
    # nix.gc = {
    #   automatic = true;
    #   interval = { Weekday = 7; }; # Every Sunday
    #   options = "--delete-older-than 14d";
    # };

    # Optimize nix store
    # nix.optimise = {
    #   automatic = true;
    #   interval = { Weekday = 7; };
    # };

    environment.systemPackages = with pkgs;
    [
      vim
      git
      wget
      curl
      tmux
      btop
      bottom
      caido # burp like
      exegol #cyber tools
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
      claude-code
      opencode
      
      
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
        # exif cleanup
        "exifcleaner"
        # ai browser
      ];
	};
}
