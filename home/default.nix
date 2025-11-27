{ pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  imports = [
    ./core.nix
    ./nixvim.nix
    ./sublime.nix
    ./tmux.nix
    ./gnome.nix
  ];

  home = {
    username = if isDarwin then "anselme" else "orion";
    homeDirectory = if isDarwin then "/Users/anselme" else "/home/orion";
    stateVersion = "24.05";
  };

  # Allow unfree packages (useful for standalone home-manager on Linux)
  nixpkgs.config.allowUnfree = true;

  # Packages are now in core.nix or apps.nix to avoid uplicates

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "$HOME/.npm-global/bin"
  ];

  programs.zsh.shellAliases = {
    copilot = "npx @github/copilot";
  };

  home.file.".npmrc".text = ''
    prefix=''${HOME}/.npm-global
  '';
  
}
