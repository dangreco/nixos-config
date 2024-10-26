{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";
    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { self, nixpkgs, home-manager, systems, ... }@inputs: 
  let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs (import systems);
  in
  rec {

    # Custom packages
    packages = forAllSystems (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in import ./pkgs { inherit pkgs; }
    );

    # Overlays
    overlays = import ./overlays { inherit inputs; };

    # NixOS configuration
    nixosConfigurations = {

      # Personal laptop
      sake = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/sake
        ];
      };

    };

    # Home-manager configurations
    homeConfigurations = {

      # Personal laptop
      "dan@sake" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [
          ./home/dan/sake.nix
        ];
      };

    };
  };
}