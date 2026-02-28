{ ... }:

{
  imports = [
    ../../home
    ./programs.nix
  ];

  home = {
    username = "anselme";
    homeDirectory = "/Users/anselme";
  };
}
