{ config, pkgs, ... }:

{
  programs.zsh = {
    shellAliases = {
      hms = "home-manager switch --flake .";
      hmsg = "home-manager switch --flake . && home-manager generations";
      hmdiff = "home-manager generations";

      # Networking & Monitoring
      ports = "sudo ss -tulanp";
      netwatch = "watch -n 1 'sudo ss -tupna | grep ESTAB'";
      listen = "sudo lsof -i -P -n | grep LISTEN";
      
      # Security Checks
      check-aslr = "cat /proc/sys/kernel/randomize_va_space";
      check-ptrace = "cat /proc/sys/kernel/yama/ptrace_scope";
      check-vuln = "nix run nixpkgs#vulnix -- --system";

      # Exploitation / RE
      pwn-env = "nix develop .#ctf";
      clippurge = "xsel -bc && xsel -c";
      clip-secret = "cat $1 | xsel -ib"; 
    };

    initContent = ''
      # Platform-specific keybindings
      bindkey '^[OH' beginning-of-line
      bindkey '^[OF' end-of-line
    '';
  };
}
