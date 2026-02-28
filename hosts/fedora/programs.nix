{ config, pkgs, ... }:

{
  programs.zsh = {
    shellAliases = {
      hms = "home-manager switch --flake .";
      hmsg = "home-manager switch --flake . && home-manager generations";
      hmdiff = "home-manager generations";

      ports = "netstat -tulanp";
      netwatch = "watch -n 1 'ss -tupna | grep ESTAB'";

      clippurge = "xsel -bc && xsel -c";
      clip-secret = "cat $1 | xsel -ib"; # Usage: clip-secret id_rsa
    };

    initContent = ''
      # Platform-specific keybindings
      bindkey '^[OH' beginning-of-line
      bindkey '^[OF' end-of-line
    '';
  };
}
