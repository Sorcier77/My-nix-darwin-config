{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false; # Left false to prevent issues with CTF nix development shells
    settings = {
      theme = "mistral-gruvbox";
      themes = {
        "mistral-gruvbox" = {
          # Mistral Gruvbox Material - Dark theme with Mistral's signature orange
          fg = "#ebdbb2";          # Foreground (Gruvbox light)
          bg = "#1a1a1a";          # Background (Charbon)
          black = "#1a1a1a";       # Charbon
          red = "#fb4934";         # Gruvbox red
          green = "#b8bb26";       # Gruvbox green
          yellow = "#fabd2f";      # Gruvbox yellow
          blue = "#83a598";        # Gruvbox blue
          magenta = "#d3869b";     # Gruvbox purple/pink
          cyan = "#8ec07c";        # Gruvbox cyan
          white = "#fbf1c7";       # Gruvbox bright fg
          orange = "#ff9500";      # Mistral signature orange
        };
      };
      pane_frames = false; # Clean look without thick borders
      default_layout = "compact"; # Saves vertical space
      simplified_ui = true; # Sleek, minimal UI
    };
  };
}
