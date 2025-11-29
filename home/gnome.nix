{ pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;

  # Script to help debug/fix fingerprint issues
  fix-fingerprint = pkgs.writeShellScriptBin "fix-fingerprint" ''
    echo "=== Fingerprint Reader Troubleshooting for ThinkPad X1 Carbon Gen 12 ==="
    echo "Device: Synaptics 06cb:0123"
    echo ""
    echo "1. Checking USB devices..."
    lsusb | grep "06cb:0123" || echo "WARNING: Fingerprint reader not found in lsusb!"

    echo ""
    echo "2. Restarting fprintd service..."
    sudo systemctl restart fprintd
    systemctl status fprintd --no-pager

    echo ""
    echo "3. Checking for firmware updates (fwupd)..."
    echo "Running: sudo fwupdmgr get-updates"
    sudo fwupdmgr get-updates

    echo ""
    echo "If devices are missing, you might be affected by a kernel regression."
    echo "Try booting an older kernel (e.g., 6.8.x) from the GRUB menu."
    echo ""
    echo "To enroll a new fingerprint, run: fprintd-enroll"
  '';

  # Script to optimize power usage
  optimize-power = pkgs.writeShellScriptBin "optimize-power" ''
    echo "=== Power Optimization for X1 Carbon Gen 12 (Fedora) ==="
    echo ""
    echo "1. Checking Power Profile (power-profiles-daemon)..."
    if command -v powerprofilesctl >/dev/null; then
      echo "Current profile:"
      powerprofilesctl get
      echo ""
      echo "Available profiles:"
      powerprofilesctl list
      echo ""
      echo "To set to power-saver: powerprofilesctl set power-saver"
    else
      echo "power-profiles-daemon not found."
    fi

    echo ""
    echo "2. Checking Powertop..."
    if command -v powertop >/dev/null; then
      echo "Run 'sudo powertop --auto-tune' to automatically tune tunable settings."
      echo "Note: This does not persist across reboots unless you create a systemd service."
    else
      echo "powertop not installed via Nix."
    fi

    echo ""
    echo "3. Intel GPU Status..."
    if command -v intel_gpu_top >/dev/null; then
        echo "Run 'sudo intel_gpu_top' to see GPU usage."
    fi
  '';
in
{
  config = lib.mkIf isLinux {
    # ===========================================================================
    #  GNOME Desktop Configuration (Clean & Polished)
    # ===========================================================================

    # Fix for white interfaces: Explicitly enable GTK theming
    gtk = {
      enable = true;

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 20;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-theme-name = "adw-gtk3-dark";
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-theme-name = "adw-gtk3-dark";
      };
    };

    # Force GTK theme for stubborn apps like virt-manager
    home.sessionVariables = {
      GTK_THEME = "adw-gtk3-dark";
    };

    # Link themes to ~/.local/share/themes for non-Nix apps
    home.activation.linkThemes = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p $HOME/.local/share/themes
      if [ -d "${pkgs.adw-gtk3}/share/themes/adw-gtk3-dark" ]; then
        rm -f "$HOME/.local/share/themes/adw-gtk3-dark"
        ln -s "${pkgs.adw-gtk3}/share/themes/adw-gtk3-dark" "$HOME/.local/share/themes/adw-gtk3-dark"
      fi
    '';

    dconf.settings = {
      # --- Interface & Theming ---
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
        enable-animations = false; # PERFORMANCE BOOST
        clock-show-weekday = true;
        show-battery-percentage = true;
        # Fonts: Using 'JetBrainsMono NFM' forces the strictly monospaced variant
        monospace-font-name = "JetBrainsMono NFM 10";
        document-font-name = "Inter 11";
        font-name = "Inter 11";
        gtk-theme = lib.mkForce "adw-gtk3-dark";
        icon-theme = "Papirus-Dark";
        cursor-theme = "Bibata-Modern-Ice";
        cursor-size = 20;
      };

      # --- Window Manager ---
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        resize-with-right-button = true;
        focus-mode = "click";
        center-new-windows = true;
      };

      # --- Extensions Management ---
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "vitals@corecoding.com"
          "caffeine@patapon.info"
          "pop-shell@system76.com"
          "just-perfection-desktop@just-perfection"
          "blur-my-shell@aunetx"
        ];
      };

      # --- Extension: Vitals (Monitoring Hardware) ---
      "org/gnome/shell/extensions/vitals" = {
        show-temperature = true;
        show-voltage = true;
        show-fan = true;
        show-memory = true;
        show-processor = true;
        show-system = true;
        position-in-panel = 0; # Left side of status area
      };

      # --- Extension: Pop Shell (Tiling) ---
      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
        show-title = false;
        snap-to-grid = true;
        active-hint = true;
        active-hint-border-radius = 5;
      };

      # --- Custom Keybindings ---
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = "kitty";
        name = "Terminal";
      };

      "org/gnome/mutter" = {
        edge-tiling = true;
        dynamic-workspaces = true;
        center-new-windows = true;
      };

      # --- Input ---
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        natural-scroll = true;
        two-finger-scrolling-enabled = true;
      };
      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = true;
      };

      # --- Privacy & Security ---
      "org/gnome/desktop/privacy" = {
        remember-recent-files = false;
        remove-old-trash-files = true;
        remove-old-temp-files = true;
        show-full-name-in-top-bar = false; # Anonymat visuel
      };

      "org/gnome/desktop/notifications" = {
        show-in-lock-screen = false; # Zéro fuite d'info PC verrouillé
        show-banners = true;
      };

      "org/gnome/desktop/screensaver" = {
        lock-enabled = true;
        lock-delay = 0; # Verrouillage immédiat après écran noir
      };

      "org/gnome/login-screen" = {
        # enable-fingerprint-authentication = true; # Managed by authselect on Fedora
      };

      # --- Power ---
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
        power-button-action = "suspend";
      };
    };

    # Install minimal GNOME tools & Themes managed by Home Manager
    home.packages = with pkgs; [
      # Tools
      gnome-tweaks
      dconf-editor
      fix-fingerprint # Custom script defined above
      optimize-power # Custom power optimization script

      # Fonts
      inter
      # Fonts are managed in core.nix (nerd-fonts.*)

      # Themes/Icons
      papirus-icon-theme
      adw-gtk3
      bibata-cursors

      # Hardware tools
      fprintd

      # GNOME Extensions
      gnomeExtensions.vitals
      gnomeExtensions.caffeine
      gnomeExtensions.pop-shell
      gnomeExtensions.just-perfection
      gnomeExtensions.blur-my-shell
    ];

    # Note on Fingerprint (Synaptics 06cb:0123):
    # If it stops working on newer kernels, it is a known regression.
    # Use 'fix-fingerprint' to debug.
    # You must also enable it in PAM:
    # sudo authselect enable-feature with-fingerprint
    # sudo authselect apply-changes
  };
}
