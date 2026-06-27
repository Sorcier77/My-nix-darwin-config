{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false; # Left false to prevent issues with CTF nix development shells
    settings = {
      theme = "catppuccin-frappe";
      pane_frames = false; # Clean look without thick borders
      default_layout = "compact"; # Saves vertical space
      simplified_ui = true; # Sleek, minimal UI
    };
  };
}
