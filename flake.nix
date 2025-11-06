{
  description = "My nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixvim, ... }:
  let
    inherit (self) outputs;
    configuration = { pkgs, ... }: {
      system.primaryUser = "anselme";

      #sudo with touchID
      security.pam.services.sudo_local.touchIdAuth = true;

      users.users.anselme = {
        name = "anselme";
        home = "/Users/anselme";
        isHidden = false;
        shell = pkgs.zsh;
      };
      
      nix.settings = {
        experimental-features = "nix-command flakes";
        # Binary caches for faster builds
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;

      nixpkgs.hostPlatform = "aarch64-darwin";
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
    };
  in
  {
    darwinConfigurations."MacBook-Pro-de-Anselme" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [
        configuration
        ./modules/apps.nix
        ./modules/system-defaults.nix

        # home manager
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.anselme = import ./home;
          home-manager.extraSpecialArgs = { inherit inputs outputs; };
          
        }
      ];
    };
  };
}
