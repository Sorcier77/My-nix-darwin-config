{ pkgs, lib, ... }:

let
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
    ./retroarch.nix
  ] ++ lib.optional isLinux ./gnome.nix;

}
