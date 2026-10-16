{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0; # Fix delay in Neovim

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
      resurrect
      continuum
      logging
    ];

    extraConfig = ''
      # --- General Settings ---
      # Fix colors for modern terminals (Kitty, Foot, Ptyxis)
      set -g default-terminal "tmux-256color"
      set -as terminal-features ",xterm-256color:RGB"
      set -as terminal-features ",foot:RGB"
      set -as terminal-features ",xterm-kitty:RGB"
      set -as terminal-overrides ",xterm*:Tc"

      # ===========================================================================
      # MISTRAL GRUVBOX MATERIAL COLORS
      # Dark theme with Mistral's signature orange and Gruvbox Material palette
      # ===========================================================================
      # Background colors
      set -g status-style "bg=#1a1a1a,fg=#ebdbb2"
      set -g window-status-current-style "bg=#282828,fg=#7aa2f7,bold"
      set -g window-status-style "bg=#1a1a1a,fg=#83a598"
      set -g pane-border-style "fg=#3a3a3a"
      set -g pane-active-border-style "fg=#7aa2f7"

      # Status bar - left side
      set -g status-left-length 20
      set -g status-left-style "bg=#282828,fg=#ebdbb2"
      set -g status-left "[\#S]"

      # Status bar - right side
      set -g status-right-style "bg=#282828,fg=#ebdbb2"
      set -g status-right "%H:%M:%S | %Y-%m-%d | #{host}"

      # Window style
      set -g window-style "bg=#1a1a1a,fg=#ebdbb2"
      set -g window-active-style "bg=#282828,fg=#9d75d0"

      # Message style
      set -g message-style "bg=#1a1a1a,fg=#e5c07b,bold"
      set -g message-command-style "bg=#1a1a1a,fg=#98c379"

      # Mode style
      set -g mode-style "bg=#7aa2f7,fg=#1a1a1a,bold"

      # Custom color palette (256 colors) - Soft Mistral Gruvbox
      set -ga terminal-colors ",#1a1a1a,#e06c75,#98c379,#e5c07b,#7aa2f7,#9d75d0,#7dcfff,#ebdbb2,#3a3a3a,#d68750,#83a598,#98c379,#e5c07b,#9ce7ff,#e06c75,#9d75d0,#fbf1c7"

      # Increase scrollback buffer
      set -g history-limit 100000

      # Status bar at top
      set-option -g status-position top

      # Start numbering at 1
      set -g base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on

      # Fix escape time for Neovim
      set -sg escape-time 0

      # --- Keybindings ---
      # Use Ctrl-a as prefix (more ergonomic than Ctrl-b)
      set -g prefix C-a
      unbind C-b
      bind C-a send-prefix

      # Intuitive Split Commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

      # --- Session Management ---
      set -g @resurrect-capture-pane-contents 'on'
      set -g @continuum-restore 'on'

      # --- Mouse & Copy ---
      set -g mouse on
      # Fix mouse scrolling in some terminals
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
      bind -n WheelDownPane select-pane -t= \; send-keys -M
    '';
  };
}
