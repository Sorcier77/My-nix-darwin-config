{ inputs, ... }:

{
  imports = [
    ../../home/common/default.nix
    ../../home/darwin/programs.nix
    ../../home/darwin/packages.nix
  ];

  home = {
    username = "anselme";
    homeDirectory = "/Users/anselme";
  };
}
