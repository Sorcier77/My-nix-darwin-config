{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    
    extraConfig = ''
      # Enable 256 colors
      set -g default-terminal "screen-256color"
      
      # Status bar at top
      set-option -g status-position top
      
      # Longer history
      set -g history-limit 10000
      
      # Windows numbering starts at 1
      set -g base-index 1
      setw -g pane-base-index 1
    '';
  };
}
