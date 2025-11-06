{ pkgs, ... }:

{
  imports = [
    ./core.nix
    ./nixvim.nix
    ./sublime.nix
  ];

  home = {
    username = "anselme";
    homeDirectory = "/Users/anselme";
    stateVersion = "24.05";
  };

  # Packages are now in core.nix or apps.nix to avoid duplicates

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
  ];

  # Copier votre fichier .p10k.zsh
  home.file.".p10k.zsh".source = ./.p10k.zsh;
  programs.zsh.shellAliases = {
    copilot = "npx @github/copilot";
  };

  home.file.".npmrc".text = ''
    prefix=''${HOME}/.npm-global
  '';
  
}
