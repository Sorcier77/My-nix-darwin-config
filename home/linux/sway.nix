{ pkgs, lib, config, ... }:

let
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    #!/usr/bin/env bash
    export PATH="/usr/sbin:/usr/bin:/bin:$PATH"

    ACTIVE_PROFILE=$(tuned-adm active 2>/dev/null | cut -d' ' -f4-)

    if [ -z "$ACTIVE_PROFILE" ]; then
        exit 1
    fi

    if [[ "$ACTIVE_PROFILE" =~ "performance" ]]; then
        STATUS="PERFORMANCE"
    elif [[ "$ACTIVE_PROFILE" =~ "powersave" || "$ACTIVE_PROFILE" =~ "battery" ]]; then
        STATUS="POWERSAVE"
    else
        STATUS="BALANCED"
    fi

    OPTIONS="1. Switch to POWERSAVE (Silent)\n2. Switch to BALANCED (Default)\n3. Switch to PERFORMANCE (Turbo)"
    CHOICE=$(echo -e "$OPTIONS" | ${pkgs.rofi}/bin/rofi -dmenu -p " POWER: $STATUS " -config $HOME/.config/rofi/config.rasi)

    case "$CHOICE" in
        *POWERSAVE*)
            tuned-adm profile powersave
            ;;
        *BALANCED*)
            tuned-adm profile balanced
            ;;
        *PERFORMANCE*)
            tuned-adm profile throughput-performance
            ;;
    esac
  '';
in
{
  # Install Sway-related user utilities
  home.packages = with pkgs; [
    power-menu
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
      
      # Gaps (makes the interface look clean and premium, hides gaps/borders when only one window is open)
      gaps = {
        inner = 8;
        outer = 4;
        smartGaps = true;
        smartBorders = "on";
      };

      # Window borders configuration
      window = {
        border = 1;
        titlebar = false; # Hide titlebars for a cleaner, modern look
        commands = [
          {
            command = "move scratchpad, resize set 950 600, move position center";
            criteria = { app_id = "scratchpad_term"; };
          }
          {
            command = "floating enable, resize set 800 500, move position center";
            criteria = { app_id = "network_manager"; };
          }
        ];
      };

      # Mistral Gruvbox Material (Soft) window border coloring
      # Charbon backgrounds with subtle Mistral orange accents
      colors = {
        focused = {
          border = "#d68750";      # Soft Mistral orange
          background = "#1a1a1a";   # Charbon
          text = "#ebdbb2";        # Gruvbox fg
          indicator = "#d68750";    # Soft Mistral orange
          childBorder = "#d68750";  # Soft Mistral orange
        };
        focusedInactive = {
          border = "#83a598";      # Gruvbox blue
          background = "#1a1a1a";   # Charbon
          text = "#83a598";        # Gruvbox blue
          indicator = "#83a598";    # Gruvbox blue
          childBorder = "#83a598";  # Gruvbox blue
        };
        unfocused = {
          border = "#3a3a3a";      # Dark gray/charbon
          background = "#1a1a1a";   # Charbon
          text = "#666666";        # Dim gray
          indicator = "#3a3a3a";    # Dark gray
          childBorder = "#3a3a3a";  # Dark gray
        };
      };

      # Status bar configuration (disable default swaybar to use Waybar)
      bars = [];

      # Custom keybindings
      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+Escape" = "exec swaymsg [app_id=\"scratchpad_term\"] scratchpad show || exec ${pkgs.kitty}/bin/kitty --class scratchpad_term";
        
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
        
        # Screen Lock (Soft Mistral orange)
        "${modifier}+Shift+x" = "exec /usr/bin/swaylock -f -c 1a1a1a --indicator-idle-visible --show-keyboard-layout --inside-color 1a1a1a00 --ring-color d68750 --key-hl-color d68750 --text-color cccccc --line-color d6875000 --inside-ver-color d6875000 --ring-ver-color 888888 --inside-wrong-color ff000000 --ring-wrong-color ff0000";

        # Sound controls (using swayosd-client for OSD indicators, auto-unmuting when raising volume)
        "XF86AudioRaiseVolume" = "exec ${pkgs.swayosd}/bin/swayosd-client --output-volume raise --max-volume 150 && /usr/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ 0";
        "XF86AudioLowerVolume" = "exec ${pkgs.swayosd}/bin/swayosd-client --output-volume lower";
        "XF86AudioMute" = "exec ${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle";
        "XF86AudioMicMute" = "exec ${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle";

        # Brightness controls (using swayosd-client for OSD indicators)
        "XF86MonBrightnessUp" = "exec ${pkgs.swayosd}/bin/swayosd-client --brightness raise";
        "XF86MonBrightnessDown" = "exec ${pkgs.swayosd}/bin/swayosd-client --brightness lower";
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
        modules-right = [ "cpu" "memory" "battery" "network" "custom/vpn" "wireplumber" ];
        
        clock = {
          format = "ORION | {:%Y-%m-%d %H:%M}";
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
          on-click-right = "${power-menu}/bin/power-menu";
        };
        network = {
          format-wifi = "IP: {ipaddr}";
          format-ethernet = "IP: {ipaddr}";
          format-disconnected = "Offline";
          on-click = "${pkgs.kitty}/bin/kitty --class network_manager nmtui";
        };
        "custom/vpn" = {
          exec = "ip addr | grep -E 'inet ' | grep -E 'tun|wg|tap' | awk '{print $2}' | cut -d'/' -f1 | head -n 1 | sed 's/^/VPN: /'";
          interval = 5;
          format = "{}";
        };
        wireplumber = {
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
        background-color: #1a1a1a;
        border-bottom: 1px solid #333333;
        color: #cccccc;
      }
      #workspaces button {
        padding: 0 12px;
        background-color: transparent;
        color: #888888;
        border-bottom: 2px solid transparent;
      }
      #workspaces button.focused {
        background-color: #282828;
        border-bottom: 2px solid #d68750;
        color: #d68750;
      }
      #workspaces button:hover {
        background-color: #333333;
        color: #cccccc;
      }
      #clock, #cpu, #memory, #battery, #custom-power, #custom-vpn, #network, #pulseaudio, #wireplumber {
        padding: 0 10px;
        margin: 0 2px;
        color: #aaaaaa;
      }
      #battery.critical:not(.charging) {
        background-color: #d68750;
        color: #1a1a1a;
        font-weight: bold;
      }
      #battery.charging {
        color: #d68750;
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
      display-drun: " ORION ";
      display-run: " SECURE ";
    }

    @theme "/dev/null"

    * {
      bg: #1a1a1a;
      bg-alt: #282828;
      fg: #cccccc;
      fg-alt: #888888;
      accent: #d68750;
      urgent: #d68750;
      
      background-color: @bg;
      text-color: @fg;
      
      margin: 0;
      padding: 0;
      spacing: 0;
    }

    window {
      width: 40%;
      border: 1px;
      border-color: #333333;
      border-radius: 4px;
      padding: 18px;
    }

    mainbox {
      children: [ inputbar, listview ];
    }

    inputbar {
      background-color: @bg-alt;
      border: 1px;
      border-color: #333333;
      border-radius: 4px;
      padding: 10px 14px;
      children: [ prompt, entry ];
      spacing: 12px;
      margin: 0 0 14px 0;
    }

    prompt {
      background-color: @accent;
      text-color: @bg;
      font: "JetBrainsMono Nerd Font Bold 11";
      padding: 4px 10px;
      border-radius: 2px;
    }

    entry {
      placeholder: "Search...";
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
      border-radius: 3px;
      spacing: 12px;
    }

    element selected {
      background-color: @accent;
      text-color: @bg;
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

  # Secure Auto-Lock and Power Saving (swayidle)
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300; # 5 minutes: Lock screen
        command = "/usr/bin/swaylock -f -c 1a1a1a --indicator-idle-visible --show-keyboard-layout --inside-color 1a1a1a00 --ring-color d68750 --key-hl-color d68750 --text-color cccccc --line-color d6875000 --inside-ver-color d6875000 --ring-ver-color 888888 --inside-wrong-color ff000000 --ring-wrong-color ff0000";
      }
      {
        timeout = 600; # 10 minutes: Turn off display to save battery
        command = "${pkgs.sway}/bin/swaymsg \"output * power off\"";
        resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * power on\"";
      }
    ];
    events = {
      before-sleep = "/usr/bin/swaylock -f -c 1a1a1a --indicator-idle-visible --show-keyboard-layout --inside-color 1a1a1a00 --ring-color d68750 --key-hl-color d68750 --text-color cccccc --line-color d6875000 --inside-ver-color d6875000 --ring-ver-color 888888 --inside-wrong-color ff000000 --ring-wrong-color ff0000";
      lock = "/usr/bin/swaylock -f -c 1a1a1a --indicator-idle-visible --show-keyboard-layout --inside-color 1a1a1a00 --ring-color d68750 --key-hl-color d68750 --text-color cccccc --line-color d6875000 --inside-ver-color d6875000 --ring-ver-color 888888 --inside-wrong-color ff000000 --ring-wrong-color ff0000";
    };
  };
}
