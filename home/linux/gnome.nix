{ pkgs, lib, config, ... }:

let
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
    else
      echo "power-profiles-daemon not found."
    fi

    echo ""
    echo "2. Checking auto-cpufreq..."
    if systemctl is-active auto-cpufreq >/dev/null 2>&1; then
      echo "auto-cpufreq is ACTIVE."
      auto-cpufreq --stats
    else
      echo "auto-cpufreq is NOT active. Consider: sudo systemctl enable --now auto-cpufreq"
    fi

    echo ""
    echo "3. Checking Thermald (Crucial for Intel Thermal Management)..."
    if systemctl is-active thermald >/dev/null 2>&1; then
      echo "thermald is ACTIVE."
    else
      echo "thermald is NOT active. Run: sudo dnf install thermald && sudo systemctl enable --now thermald"
    fi

    echo ""
    echo "4. Checking Powertop..."
    if command -v powertop >/dev/null; then
      echo "Run 'sudo powertop --auto-tune' to automatically tune tunable settings."
    fi

    echo ""
    echo "5. Intel GPU Status..."
    if command -v intel_gpu_top >/dev/null; then
        echo "Run 'sudo intel_gpu_top' to see GPU usage."
    fi
  '';
in
{
  config = {
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

      gtk4.theme = config.gtk.theme;

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-theme-name = "adw-gtk3-dark";
      };

      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-theme-name = "adw-gtk3-dark";
      };
    };

    # Force GTK theme and hardware acceleration for stubborn apps
    home.sessionVariables = {
      GTK_THEME = "adw-gtk3-dark";
      # Intel Hardware Acceleration (Pro/Cyber settings for X1 Carbon Gen 12)
      LIBVA_DRIVER_NAME = "iHD";
      VDPAU_DRIVER = "va_gl";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      NIXOS_OZONE_WL = "1"; # Hint for Electron apps
      GNOME_SHELL_SLOWDOWN_FACTOR = "1.0"; # ⚡ Clean, sleek, and smooth default animations (1.0 is default)
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
        enable-animations = true; # Smooth & professional animations
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
        # Custom accent color (Soft Mistral blue)
        accent-color = lib.mkForce "#7aa2f7";
      };

      # --- Window Manager (Minimalisme Pur) ---
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:close"; # Minimalisme : on enlève minimize/maximize (inutile avec les workspaces virtuels)
        resize-with-right-button = true;
        focus-mode = "click";
        center-new-windows = true;
        num-workspaces = 4; # Fixe un nombre de bureaux virtuels nets
      };

      # Raccourcis de navigation ultra-rapides entre les bureaux virtuels
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
        move-to-workspace-1 = ["<Super><Shift>1"];
        move-to-workspace-2 = ["<Super><Shift>2"];
        move-to-workspace-3 = ["<Super><Shift>3"];
        move-to-workspace-4 = ["<Super><Shift>4"];
        close = ["<Super>q" "<Alt>F4"]; # Fermeture instantanée
        toggle-fullscreen = ["<Super>f"];
        toggle-maximized = []; # Désactivé pour utiliser les raccourcis classiques ci-dessous

        # Raccourcis classiques de gestion des fenêtres GNOME
        minimize = [];
        maximize = ["<Super>Up"]; # Maximiser la fenêtre (remplit l'écran mais pas plein écran)
        unmaximize = ["<Super>Down"]; # Restaurer la taille de la fenêtre
        switch-to-workspace-left = [];
        switch-to-workspace-right = [];
        switch-to-workspace-up = [];
        switch-to-workspace-down = [];
        move-to-workspace-left = [];
        move-to-workspace-right = [];
        move-to-workspace-up = [];
        move-to-workspace-down = [];
        move-to-monitor-left = ["<Super><Shift>Left"]; # Déplacer la fenêtre vers l'écran de gauche
        move-to-monitor-right = ["<Super><Shift>Right"]; # Déplacer la fenêtre vers l'écran de droite
        move-to-monitor-up = [];
        move-to-monitor-down = [];
        switch-input-source = [];
        switch-input-source-backward = [];
      };

      # Raccourcis Mutter pour le tuilage classique à gauche/droite
      "org/gnome/mutter/keybindings" = {
        toggle-tiled-left = ["<Super>Left"]; # Occuper la moitié gauche de l'écran
        toggle-tiled-right = ["<Super>Right"]; # Occuper la moitié droite de l'écran
      };

      # Suppression des conflits GNOME par défaut (Super+1,2,3,4 ouvraient les applis du Dash, Super+m ouvrait le message tray)
      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = [];
        switch-to-application-2 = [];
        switch-to-application-3 = [];
        switch-to-application-4 = [];
        switch-to-application-5 = [];
        switch-to-application-6 = [];
        switch-to-application-7 = [];
        switch-to-application-8 = [];
        switch-to-application-9 = [];
        toggle-message-tray = [ "<Super>v" ]; # Libère <Super>m pour maximiser sous Pop Shell (gardant seulement <Super>v)
      };

      # --- Extensions Management ---
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "caffeine@patapon.info"
          "just-perfection-desktop@just-perfection"
          "run-or-raise@edvard.cz"
        ];
      };

      # --- Custom Keybindings ---
      "org/gnome/settings-daemon/plugins/media-keys" = {
        screensaver = [ "<Super>l" ]; # Verrouillage de la session avec Super+L
        custom-keybindings = [];
      };

      # --- Terminal: Ptyxis Configuration (Mistral Gruvbox Material theme) ---
      "org/gnome/Ptyxis" = {
        restore-session = true;
        use-header-bar = true;
        font-name = "JetBrainsMono NFM 10";
        cursor-shape = "ibeam";
        cursor-blink-mode = "on";
        audible-bell = false;
        visual-bell = false;
        scrollbar-policy = "never";
        # Mistral Gruvbox Material palette
        # Ptyxis uses named profiles or system theme by default
        # Colors are controlled via GTK theme, but we can set a custom profile
        # Using system GTK dark theme with our accent colors
      };

      "org/gnome/mutter" = {
        edge-tiling = true;
        dynamic-workspaces = false; # Bureaux fixes (plus prédictible pour le workflow)
        center-new-windows = true;
        workspaces-only-on-primary = true;
        experimental-features = [ "variable-refresh-rate" "scale-monitor-framebuffer" "rt-scheduler" ];
      };

      # --- Sharpness & Focus (Just Perfection) ---
      "org/gnome/shell/extensions/just-perfection" = {
        animation = 1; # Enable default smooth animations
        behavior-focus-mode = 0;
        clock-menu-position = 0;
        clock-menu-position-offset = 0;
        dash = false; # Hide dash for cleaner 'pro' look
        double-click-delay = 200;
        startup-status = 0;
        theme = true;
        top-panel = true;
        window-demands-attention-focus = true;
        workspaces-in-app-grid = false;
        search = true;
        # Tweak extrême : cache tout ce qui est inutile dans la top bar
        accessibility-menu = false;
        activities-button = false;
        keyboard-layout = false;
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
        report-technical-problems = false; # OpSec: Disable crash reports
        send-software-usage-stats = false; # OpSec: Disable usage stats
      };

      "org/gnome/system/location" = {
        enabled = false; # OpSec: Disable location services globally
      };

      # --- Disable File Indexing (Security & Performance) ---
      # Empêche l'indexation de fichiers sensibles et économise drastiquement la batterie/I/O
      "org/freedesktop/Tracker3/Miner/Files" = {
        index-recursive-directories = [];
        index-single-directories = [];
      };

      # --- Disable Background Updates (Performance) ---
      # Évite la consommation RAM/CPU en arrière-plan puisque les MAJ se font via Nix
      "org/gnome/software" = {
        download-updates = false;
        allow-updates = false;
      };

      "org/gnome/desktop/session" = {
        idle-delay = 300; # Lock screen after 5 minutes of inactivity (locks immediately due to lock-delay=0)
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

    # Configuration of the Run or Raise extension to reuse existing Kitty window
    home.file.".config/run-or-raise/shortcuts.conf".text = ''
      <Super>Return,${pkgs.kitty}/bin/kitty,kitty,
    '';

    # Install minimal GNOME tools & Themes managed by Home Manager
    home.packages = with pkgs; [
      # Terminal
      ptyxis

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
      gnomeExtensions.caffeine
      gnomeExtensions.just-perfection
      gnomeExtensions.run-or-raise
    ];

    # Note on Fingerprint (Synaptics 06cb:0123):
    # If it stops working on newer kernels, it is a known regression.
    # Use 'fix-fingerprint' to debug.
    # You must also enable it in PAM:
    # sudo authselect enable-feature with-fingerprint
    # sudo authselect apply-changes
  };
}
