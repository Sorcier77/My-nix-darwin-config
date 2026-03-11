{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 0; # Zéro délai pour Neovim
    
    # Plugins premium pour un agent
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_tabs_enabled on
          set -g @catppuccin_date_time "%H:%M"
        '';
      }
      {
        # Sauvegarde automatique des sessions (résiste aux redémarrages)
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        # Restauration continue
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
      {
        # Logging des sessions (Crucial en Opération)
        plugin = logging;
      }
      yank # Intégration parfaite du presse-papiers
    ];

    extraConfig = ''
      # --- TRUE COLOR SUPPORT (Ghostty & Neovim compatibility) ---
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ag terminal-overrides ",ghostty:RGB"

      # --- UI & UX ---
      set-option -g status-position top
      set -g history-limit 100000 # Historique massif pour le reverse
      set -g renumber-windows on

      # --- VIM KEYBINDINGS FOR PANES ---
      # Split avec | et - (plus instinctif)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Navigation Vim (h,j,k,l)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Redimensionnement Vim
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Synchronisation des panes (taper la même commande partout)
      bind y set-window-option synchronize-panes
    '';
  };
}
