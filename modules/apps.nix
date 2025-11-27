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
      options = "--delete-older-than 14d";
    };

    # Optimize nix store
    nix.optimise = {
      automatic = true;
      interval = { Weekday = 7; };
    };

    environment.systemPackages = with pkgs;
    [
      # Packages have been moved to home/core.nix for cross-platform compatibility
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
	"raycast"
        "sublime-text"
        "tomatobar"
	"wireshark"
	"vnc-viewer"
      ];
	};
}
