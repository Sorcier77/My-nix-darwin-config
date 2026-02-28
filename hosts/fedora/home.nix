{ ... }:

{
  imports = [
    ../../home
  ];

  # Essential for non-NixOS Linux (Fedora, Ubuntu, etc.)
  # This links .desktop files so apps appear in the menu
  targets.genericLinux.enable = true;

  home = {
    username = "orion";
    homeDirectory = "/home/orion";
  };
}
