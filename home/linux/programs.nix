{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    shellAliases = {
      # Linux-specific aliases
      hms = "home-manager switch --flake .";
      hmsg = "home-manager switch --flake . && home-manager generations";
      hmdiff = "home-manager generations";

      # Networking & Monitoring (Linux)
      ports = "sudo ss -tulanp";
      netwatch = "watch -n 1 'sudo ss -tupna | grep ESTAB'";
      listen = "sudo lsof -i -P -n | grep LISTEN";
      
      # Power Management (Linux)
      power = "power-status";

      # Security Checks (Linux)
      check-aslr = "cat /proc/sys/kernel/randomize_va_space";
      check-ptrace = "cat /proc/sys/kernel/yama/ptrace_scope";
      check-vuln = "nix run nixpkgs#vulnix -- --system";

      # Exploitation / RE
      pwn-env = "nix develop .#ctf";
      clippurge = "xsel -bc && xsel -c";
      clip-secret = "cat $1 | xsel -ib"; 
    };

    initContent = ''
      # Platform-specific keybindings for Linux Terminal
      bindkey '^[OH' beginning-of-line
      bindkey '^[OF' end-of-line
    '';
  };
}
