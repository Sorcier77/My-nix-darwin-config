{ pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    ./general.nix
    ./packages.nix
    ./programs.nix
    ./nixvim.nix
    ./sublime.nix
    ./tmux.nix
    ./gnome.nix
  ];

  # Essential for non-NixOS Linux (Fedora, Ubuntu, etc.)
  # This links .desktop files so apps appear in the menu
  targets.genericLinux.enable = isLinux;

  home = {
    username = if isDarwin then "anselme" else "orion";
    homeDirectory = if isDarwin then "/Users/anselme" else "/home/orion";
  };
}
