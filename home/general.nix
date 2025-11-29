{ pkgs, lib, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Better integration for non-NixOS Linux
  targets.genericLinux.enable = isLinux;

  fonts.fontconfig.enable = true;

  home.stateVersion = "24.05";

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "$HOME/.npm-global/bin"
  ];

  home.file.".npmrc".text = ''
    prefix=''${HOME}/.npm-global
  '';

  home.activation.installNerdFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Linking Nerd Fonts to ~/.local/share/fonts..."
    mkdir -p $HOME/.local/share/fonts
    find $HOME/.nix-profile/share/fonts -name "*NerdFont*.ttf" -exec ln -sf {} $HOME/.local/share/fonts/ \;
    echo "Updating font cache..."
    ${pkgs.fontconfig}/bin/fc-cache -f $HOME/.local/share/fonts
  '';
}
