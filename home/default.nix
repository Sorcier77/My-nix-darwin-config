{ pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
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

  home = {
    username = if isDarwin then "anselme" else "orion";
    homeDirectory = if isDarwin then "/Users/anselme" else "/home/orion";
  };
}
