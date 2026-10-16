{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false; # Left false to prevent issues with CTF nix development shells
    settings = {
      theme = "monochrome";
      themes = {
        monochrome = {
          fg = "#c0c0c0";
          bg = "#000000";
          black = "#000000";
          red = "#ffffff";
          green = "#ffffff";
          yellow = "#888888";
          blue = "#ffffff";
          magenta = "#ffffff";
          cyan = "#888888";
          white = "#ffffff";
          orange = "#ffffff";
        };
      };
      pane_frames = false; # Clean look without thick borders
      default_layout = "compact"; # Saves vertical space
      simplified_ui = true; # Sleek, minimal UI
    };
  };
}
