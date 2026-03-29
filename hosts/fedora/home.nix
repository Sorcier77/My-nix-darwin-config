{ inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../../home
    ../../home/gnome.nix
    ./programs.nix
    ./packages.nix
  ];

  # Basic SOPS Configuration
  sops = {
    defaultSopsFile = ../../secrets.yaml; # Place your encrypted secrets here
    age.keyFile = "/home/orion/.config/sops/age/keys.txt"; # Use age for modern encryption
    # Optional: use GPG instead
    # gnupg.home = "/home/orion/.gnupg";
    # gnupg.sshKeyPaths = [];
  };

  # Essential for non-NixOS Linux (Fedora, Ubuntu, etc.)
  # This links .desktop files so apps appear in the menu
  targets.genericLinux.enable = true;

  home = {
    username = "orion";
    homeDirectory = "/home/orion";
  };
}
