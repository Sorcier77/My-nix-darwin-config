{ pkgs, lib, config, ... }:

{
  # Install Sway-related user utilities
  home.packages = with pkgs; [
    waybar
    rofi
    swaybg
    grim
    slurp
    swaylock-effects
    swayidle
    wl-clipboard
    brightnessctl
  ];

  # Configure Sway directly via Home Manager
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # Super key (Windows Key)
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "env PATH=${config.home.homeDirectory}/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH ${pkgs.rofi}/bin/rofi -show drun -show-icons";

      # Use Vim keys for focus and movement
      left = "h";
      down = "j";
      up = "k";
      right = "l";

      # French AZERTY Keyboard layout and touchpad configuration
      input = {
        "*" = {
          xkb_layout = "fr";
        };
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };
      
      # Gaps (makes the interface look clean and premium)
      gaps = {
        inner = 8;
        outer = 4;
      };

      # Window borders configuration
      window = {
        border = 1;
        titlebar = false; # Hide titlebars for a cleaner, modern look
      };

      # Status bar configuration (disable default swaybar to use Waybar)
      bars = [];

      # Custom keybindings
      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${menu}";
        
        # Close active window (Super+q for fast, professional exit, Alt+F4 fallback)
        "${modifier}+q" = "kill";
        "Mod1+F4" = "kill";
        
        # Move focus using Vim keys
        "${modifier}+${left}" = "focus left";
        "${modifier}+${down}" = "focus down";
        "${modifier}+${up}" = "focus up";
        "${modifier}+${right}" = "focus right";

        # Move windows using Vim keys
        "${modifier}+Shift+${left}" = "move left";
        "${modifier}+Shift+${down}" = "move down";
        "${modifier}+Shift+${up}" = "move up";
        "${modifier}+Shift+${right}" = "move right";

        # Layout toggles
        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+Shift+space" = "floating toggle";

        # Disable default QWERTY number bindings to avoid conflicts on AZERTY
        "${modifier}+1" = null;
        "${modifier}+2" = null;
        "${modifier}+3" = null;
        "${modifier}+4" = null;
        "${modifier}+5" = null;
        "${modifier}+6" = null;
        "${modifier}+7" = null;
        "${modifier}+8" = null;
        "${modifier}+9" = null;
        "${modifier}+0" = null;
        "${modifier}+Shift+1" = null;
        "${modifier}+Shift+2" = null;
        "${modifier}+Shift+3" = null;
        "${modifier}+Shift+4" = null;
        "${modifier}+Shift+5" = null;
        "${modifier}+Shift+6" = null;
        "${modifier}+Shift+7" = null;
        "${modifier}+Shift+8" = null;
        "${modifier}+Shift+9" = null;
        "${modifier}+Shift+0" = null;
        "${modifier}+Shift+q" = null;

        # French AZERTY Workspace switching (binding directly to the top-row keys)
        "${modifier}+ampersand" = "workspace number 1";
        "${modifier}+eacute" = "workspace number 2";
        "${modifier}+quotedbl" = "workspace number 3";
        "${modifier}+apostrophe" = "workspace number 4";
        "${modifier}+parenleft" = "workspace number 5";
        "${modifier}+minus" = "workspace number 6";
        "${modifier}+egrave" = "workspace number 7";
        "${modifier}+underscore" = "workspace number 8";
        "${modifier}+ccedilla" = "workspace number 9";
        "${modifier}+agrave" = "workspace number 10";

        # Move active container to AZERTY workspaces
        "${modifier}+Shift+ampersand" = "move container to workspace number 1";
        "${modifier}+Shift+eacute" = "move container to workspace number 2";
        "${modifier}+Shift+quotedbl" = "move container to workspace number 3";
        "${modifier}+Shift+apostrophe" = "move container to workspace number 4";
        "${modifier}+Shift+parenleft" = "move container to workspace number 5";
        "${modifier}+Shift+minus" = "move container to workspace number 6";
        "${modifier}+Shift+egrave" = "move container to workspace number 7";
        "${modifier}+Shift+underscore" = "move container to workspace number 8";
        "${modifier}+Shift+ccedilla" = "move container to workspace number 9";
        "${modifier}+Shift+agrave" = "move container to workspace number 10";

        # Screenshots (Print Screen to select a region, copy to clipboard)
        "Print" = "exec ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";
        
        # Screen Lock (Sleek blur effect with lock clock, Super+Shift+x, AZERTY layout, high security blur)
        "${modifier}+Shift+x" = "exec ${pkgs.swaylock-effects}/bin/swaylock --screenshots --clock --indicator --show-keyboard-layout --effect-blur 20x15 --ring-color ca9ee6 --key-hl-color 81c8be --text-color c6d0f5";

        # Sound controls (using SwayOSD client)
        "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
        "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
        "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";
        "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";

        # Brightness controls (using SwayOSD client)
        "XF86MonBrightnessUp" = "exec swayosd-client --brightness raise";
        "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower";
      };

      # Startup applications
      startup = [
        { command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK"; }
        { command = "${pkgs.swaybg}/bin/swaybg -m fill -i /home/orion/Pictures/wallpaper.jpg"; always = true; }
        { command = "pkill waybar || true && ${pkgs.waybar}/bin/waybar"; always = true; }
        { command = "swaymsg workspace number 1"; }
      ];
    };
  };

  # Waybar configuration (Sleek, minimal, emoji-free status bar)
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "battery" "network" "pulseaudio" ];
        
        clock = {
          format = "SYS: {:%Y-%m-%d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        cpu = {
          format = "CPU: {usage}% {icon}";
          format-icons = [ " " "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          tooltip = false;
        };
        memory = {
          format = "RAM: {percentage}% {icon}";
          format-icons = [ " " "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "BAT: {capacity}%";
          format-charging = "BAT: {capacity}%";
          format-plugged = "BAT: {capacity}%";
          format-alt = "BAT: {time}";
        };
        network = {
          format-wifi = "WIFI: {essid} | IP: {ipaddr}";
          format-ethernet = "ETH: {ifname} | IP: {ipaddr}";
          format-disconnected = "NET: Offline";
        };
        pulseaudio = {
          format = "VOL: {volume}%";
          format-muted = "VOL: Muted";
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono NFM", Roboto, Helvetica, Arial, sans-serif;
        font-size: 13px;
        border: none;
        border-radius: 0;
      }
      window#waybar {
        background-color: #1b1d24;
        border-bottom: 1px solid #2d3139;
        color: #c6d0f5;
      }
      #workspaces button {
        padding: 0 12px;
        background-color: transparent;
        color: #c6d0f5;
        border-bottom: 2px solid transparent;
      }
      #workspaces button.focused {
        background-color: #2d3139;
        border-bottom: 2px solid #8caaee;
        color: #fff;
      }
      #workspaces button:hover {
        background-color: #23252e;
      }
      #clock, #cpu, #memory, #battery, #network, #pulseaudio {
        padding: 0 10px;
        margin: 0 2px;
        color: #b5bfe2;
      }
      #battery.critical:not(.charging) {
        background-color: #e78284;
        color: #1b1d24;
      }
      #battery.charging {
        color: #a6da95; /* Cyber green text when charging */
      }
    '';
  };

  # Beautiful premium dark Rofi theme (Spotlight/Alfred style)
  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
      modi: "drun,run";
      show-icons: true;
      icon-theme: "Papirus";
      terminal: "kitty";
      drun-display-format: "{name}";
      location: 0;
      disable-history: false;
      hide-scrollbar: true;
      display-drun: " APPS ";
      display-run: " RUN ";
    }

    @theme "/dev/null"

    * {
      bg: #1b1d24;
      bg-alt: #2d3139;
      fg: #c6d0f5;
      fg-alt: #8b92b6;
      accent: #8caaee;
      urgent: #e78284;
      
      background-color: @bg;
      text-color: @fg;
      
      margin: 0;
      padding: 0;
      spacing: 0;
    }

    window {
      width: 45%;
      border: 1px;
      border-color: @bg-alt;
      border-radius: 12px;
      padding: 16px;
    }

    mainbox {
      children: [ inputbar, listview ];
    }

    inputbar {
      background-color: @bg-alt;
      border-radius: 8px;
      padding: 10px 14px;
      children: [ prompt, entry ];
      spacing: 10px;
      margin: 0 0 12px 0;
    }

    prompt {
      background-color: @accent;
      text-color: @bg;
      font: "JetBrainsMono Nerd Font Bold 12";
      padding: 4px 8px;
      border-radius: 4px;
    }

    entry {
      placeholder: "Search applications...";
      placeholder-color: @fg-alt;
      font: "JetBrainsMono Nerd Font 12";
      vertical-align: 0.5;
    }

    listview {
      lines: 8;
      columns: 1;
      fixed-height: true;
      cycle: true;
      scrollbar: false;
    }

    element {
      padding: 8px 12px;
      border-radius: 6px;
      spacing: 12px;
    }

    element selected {
      background-color: @bg-alt;
      text-color: @accent;
    }

    element-icon {
      size: 24px;
      vertical-align: 0.5;
      background-color: transparent;
    }

    element-text {
      vertical-align: 0.5;
      font: "JetBrainsMono Nerd Font 11";
      background-color: transparent;
      text-color: inherit;
    }
  '';

  # Enable the SwayOSD background server daemon
  services.swayosd.enable = true;
}
