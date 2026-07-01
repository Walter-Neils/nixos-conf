{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "github:hyprwm/Hyprland?ref=v0.55.4";
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "unstable";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      unstable,
      nixos-hardware,
      ...
    }:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import unstable {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      };
      overlay-stable = final: prev: {
        stable = nixpkgs.legacyPackages.${prev.system};
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs nixpkgs unstable; };
        modules = [
          ./configuration.nix
          {
            nix = {
              channel.enable = false;
              registry = {
                nixpkgs.flake = nixpkgs;
                unstable.flake = unstable;
                nixos-hardware.flake = nixos-hardware;
              };
            };

            nixpkgs.overlays = [
              overlay-stable
              overlay-unstable
            ];

            nix.nixPath = [
              "nixpkgs=${nixpkgs.outPath}"
              "unstable=${unstable.outPath}"
            ];

            nix.settings = {
              substituters = [ "https://hyprland.cachix.org" ];
              trusted-substituters = [ "https://hyprland.cachix.org" ];
              trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
            };
          }
        ];
      };
    };
}
