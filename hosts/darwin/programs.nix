{ config, pkgs, ... }:

{
  programs.zsh = {
    shellAliases = {
      hms = "darwin-rebuild switch --flake ~/.config/nix-darwin";
      hmsg = "darwin-rebuild switch --flake ~/.config/nix-darwin && darwin-rebuild --list-generations";
      hmdiff = "darwin-rebuild --list-generations";

      ports = "lsof -iTCP -sTCP:LISTEN -n -P";
      netwatch = "watch -n 1 'lsof -i | grep ESTABLISHED'";

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
      # Platform-specific keybindings
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
    '';
  };
}
