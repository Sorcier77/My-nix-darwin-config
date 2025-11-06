{ pkgs, ... }:

{
  imports = [
    ./core.nix
    ./nixvim.nix
    ./sublime.nix
    ./tmux.nix
  ];

  home = {
    username = "anselme";
    homeDirectory = "/Users/anselme";
    stateVersion = "24.05";
  };

  # Packages are now in core.nix or apps.nix to avoid duplicates

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
