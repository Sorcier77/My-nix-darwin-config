{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    shellAliases = {
      # Darwin-specific aliases
      hms = "darwin-rebuild switch --flake /home/orion/Documents/My-nix-darwin-config";
      hmsg = "darwin-rebuild switch --flake /home/orion/Documents/My-nix-darwin-config && darwin-rebuild --list-generations";
      hmdiff = "darwin-rebuild --list-generations";

      # macOS-specific tools
      ports = "lsof -iTCP -sTCP:LISTEN -n -P";
      netwatch = "watch -n 1 'lsof -i | grep ESTABLISHED'";

      # macOS clipboard
      clippurge = "pbcopy < /dev/null";
      clip-secret = "cat $1 | pbcopy"; # Usage: clip-secret id_rsa
    };

    oh-my-zsh = {
      plugins = [
        "macos"
        "brew"
      ];
    };

    initContent = ''
      # Platform-specific keybindings for macOS Terminal
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
    '';
  };
}
