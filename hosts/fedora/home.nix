{ inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../home/common/default.nix
    ../../home/linux/gnome.nix
    ../../home/linux/sway.nix
    ../../home/linux/programs.nix
    ../../home/linux/packages.nix
    ../../home/linux/sops.nix
  ];

  # Basic SOPS Configuration
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    age.keyFile = "/home/orion/.config/sops/age/keys.txt";
  };

  # Essential for non-NixOS Linux (Fedora, Ubuntu, etc.)
  targets.genericLinux.enable = true;

  home = {
    username = "orion";
    homeDirectory = "/home/orion";
  };
}
