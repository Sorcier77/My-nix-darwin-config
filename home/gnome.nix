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
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    dconf.settings = {
      # --- Interface & Theming ---
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
        clock-show-weekday = true;
        show-battery-percentage = true;
        # Fonts: Using 'JetBrainsMono NFM' forces the strictly monospaced variant
        monospace-font-name = "JetBrainsMono NFM 10";
        document-font-name = "Inter 11";
        font-name = "Inter 11";
        gtk-theme = lib.mkForce "adw-gtk3-dark";
        icon-theme = "Papirus-Dark";
        cursor-theme = "Bibata-Modern-Ice";
      };

      # --- Window Manager ---
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        resize-with-right-button = true;
        focus-mode = "click";
        center-new-windows = true;
      };

      # --- Custom Keybindings ---
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = "ptyxis --new-window";
        name = "Terminal";
      };
      
      "org/gnome/mutter" = {
        edge-tiling = true;
        dynamic-workspaces = true;
        center-new-windows = true;
      };

      # --- Shell / Dock (Clean Look) ---
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = "BOTTOM";
        dash-max-icon-size = 32;
        show-trash = false;
        show-mounts = false;
        dock-fixed = false;
        autohide = true;
        extend-height = false;
        transparency-mode = "FIXED";
        custom-background-color = true;
        background-color = "#000000";
        background-opacity = 0.8;
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
      
      # Fonts
      inter
      # Fonts are managed in core.nix (nerd-fonts.*)
      
      # Themes/Icons
      papirus-icon-theme
      adw-gtk3
      bibata-cursors
      
      # Hardware tools
      fprintd
    ];
    
    # Note on Fingerprint (Synaptics 06cb:0123):
    # If it stops working on newer kernels, it is a known regression.
    # Use 'fix-fingerprint' to debug.
    # You must also enable it in PAM:
    # sudo authselect enable-feature with-fingerprint
    # sudo authselect apply-changes
  };
}
