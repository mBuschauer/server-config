{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      overlay-stable = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      settings = import (./. + "/settings.nix") { inherit pkgs; };
      secrets = import (./. + "/secrets.nix") { inherit pkgs; };
    in
    {
      nixosConfigurations."${settings.hostname}" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit settings;
          inherit secrets;
        };
        modules = [
          ({ config, pkgs, ... }:
            {
              nixpkgs.overlays = [ overlay-stable ];
            }
          )
          ./configuration.nix
        ];
      };
    };
}
