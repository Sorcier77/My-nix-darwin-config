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
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'frappe'
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"
          set -g @catppuccin_status_modules_right "directory user host session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator ""
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{pane_current_path}"
        '';
      }
    ];

    extraConfig = ''
      # --- General Settings ---
      # Fix colors for modern terminals (Kitty, Foot, Ptyxis)
      set -g default-terminal "tmux-256color"
      set -as terminal-features ",xterm-256color:RGB"
      set -as terminal-features ",foot:RGB"
      set -as terminal-features ",xterm-kitty:RGB"
      set -as terminal-overrides ",xterm*:Tc"

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
