{
  description = "WAV - flake";

  inputs = {
    # Stable for system
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Unstable for specific packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";  # Follow stable for home-manager
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
  let
    system = "x86_64-linux";

    # Import package sets
    pkgs = import nixpkgs { inherit system; };
    unstable = import nixpkgs-unstable { inherit system; };
    
  in
  {
    nixosConfigurations.WAV = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs;
        inherit unstable;  # Pass unstable package set to modules
      };

      modules = [
        # Global nixpkgs configuration (using stable)
        {
          nixpkgs.config.allowUnfree = true;
        }

        # Base system (uses stable)
        ./nixos/configuration.nix

        # Home Manager as NixOS module (uses stable via follows)
        home-manager.nixosModules.home-manager

        # Home Manager configuration
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;



          home-manager.users.durian = {
            imports = [
              ./home.nix
            ];
          };
        }

        # My  custom modules
        ./nixos/modules/hyprland.nix
      ];
    };
  };
}
