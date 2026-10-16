{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false; # Left false to prevent issues with CTF nix development shells
    settings = {
      theme = "mistral-gruvbox";
      themes = {
        "mistral-gruvbox" = {
          # Mistral Gruvbox Material (Soft) - Dark theme with subtle Mistral colors
          fg = "#ebdbb2";          # Foreground (Gruvbox light)
          bg = "#1a1a1a";          # Background (Charbon)
          black = "#1a1a1a";       # Charbon
          red = "#e06c75";         # Softer red
          green = "#98c379";       # Softer green
          yellow = "#e5c07b";      # Softer yellow
          blue = "#7aa2f7";        # Mistral blue
          magenta = "#9d75d0";     # Mistral purple
          cyan = "#7dcfff";        # Softer cyan
          white = "#fbf1c7";       # Gruvbox bright fg
          orange = "#d68750";      # Soft Mistral orange
        };
      };
      pane_frames = false; # Clean look without thick borders
      default_layout = "compact"; # Saves vertical space
      simplified_ui = true; # Sleek, minimal UI
    };
  };
}
