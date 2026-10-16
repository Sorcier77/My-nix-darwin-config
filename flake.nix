{
  description = "My nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    burpsuitepro = {
      type = "github";
      owner = "xiv3r";
      repo = "Burpsuite-Professional";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      nixvim,
      ...
    }:
    let
      inherit (self) outputs;
      
      # Shared overlay to disable failing Python package tests
      pythonOverlay = (self: super: {
        python312Packages = super.python312Packages.override (old: {
          anyio = super.python312Packages.anyio.overrideAttrs (oldAttrs: {
            doCheck = false;
          });
          httpcore = super.python312Packages.httpcore.overrideAttrs (oldAttrs: {
            doCheck = false;
          });
          httpx = super.python312Packages.httpx.overrideAttrs (oldAttrs: {
            doCheck = false;
          });
          proxy-py = super.python312Packages.proxy-py.overrideAttrs (oldAttrs: {
            doCheck = false;
          });
          certipy-ad = super.python312Packages.certipy-ad.overrideAttrs (oldAttrs: {
            doCheck = false;
          });
          netexec = super.python312Packages.netexec.overrideAttrs (oldAttrs: {
            doCheck = false;
          });
        });
      });
      
      configuration =
        { pkgs, ... }:
        {
          system.primaryUser = "anselme";

          # sudo with touchID
          security.pam.services.sudo_local.touchIdAuth = true;

          users.users.anselme = {
            name = "anselme";
            home = "/Users/anselme";
            isHidden = false;
            shell = pkgs.zsh;
          };

          nix.settings = {
            experimental-features = "nix-command flakes";
            auto-optimise-store = true;
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
        specialArgs = { inherit inputs outputs; };
        modules = [
          configuration
          ./modules/apps.nix
          ./modules/system-defaults.nix

          # home manager
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.anselme = import ./hosts/darwin/home.nix { inherit inputs; };
            home-manager.extraSpecialArgs = { inherit inputs outputs; };
            
            # Fix Python package test failures
            nixpkgs.overlays = [ pythonOverlay ];
          }
        ];
      };

      # Home Manager configuration for Fedora (Linux x86_64)
      homeConfigurations."orion" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [
          (import ./hosts/fedora/home.nix { inherit inputs; })
          {
            # Ensure unfree packages are allowed
            nixpkgs.config.allowUnfree = true;
            # Fix Python package test failures
            nixpkgs.overlays = [ pythonOverlay ];
          }
        ];
      };

      devShells.x86_64-linux.ctf =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            config.permittedInsecurePackages = [
              "gradle-7.6.6"
            ];
          };
          stable = import nixpkgs-stable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        in
        import ./modules/ctf-shell.nix { inherit pkgs stable; };
    };
}
