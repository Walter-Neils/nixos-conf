{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    hyprland.url = "github:hyprwm/Hyprland?ref=main";
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    gsr-ui = {
      url = "github:rPlakama/gsr-ui-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      ...
    }:
    let
      hostSystem = host: host.system or "x86_64-linux";
      overlay-unstable = system: final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      };
      overlay-stable = final: prev: {
        stable = nixpkgs.legacyPackages.${prev.system};
      };

      hosts = [
        { name = "NCC-1701-C"; }
        { name = "NCC-1701-D"; }
        { name = "kamikaze"; }
        { name = "win-tiny"; }
        { name = "savtop"; }
        { name = "win-worktop"; }
        { name = "gh-runner"; }
        { name = "minecraft-server"; }
        { name = "ventry-nas"; }
        { name = "oci-primary"; system = "aarch64-linux"; }
        { name = "meltop"; }
        { name = "portable"; }
      ];
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host.name;
          value = nixpkgs.lib.nixosSystem {
            system = hostSystem host;
            specialArgs = { inherit inputs nixpkgs nixpkgs-unstable; };
            modules = [
              # Declarative flatpak
              inputs.nix-flatpak.nixosModules.nix-flatpak
              # Declarative disk partitioning (nixos-anywhere)
              inputs.disko.nixosModules.disko
              ./modules/custom-options/all.nix
              ./modules/common.nix
              ./hosts/${host.name}/configuration.nix
              {
	        imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
                system.configurationRevision = if (self ? rev) then self.rev else "dirty";
                networking.hostName = host.name;
                nix = {
                  channel.enable = false;
                  registry = {
                    nixpkgs.flake = nixpkgs;
                    unstable.flake = nixpkgs-unstable;
                    nixos-hardware.flake = nixos-hardware;
                  };
                };

                nixpkgs.overlays = [
                  overlay-stable
                  (overlay-unstable (hostSystem host))
		  inputs.nix-minecraft.overlay
                ];

                environment.etc."nix/inputs/nixpkgs".source = nixpkgs.outPath;
                environment.etc."nix/inputs/unstable".source = nixpkgs-unstable.outPath;

                nix.nixPath = [
                  "nixpkgs=/etc/nix/inputs/nixpkgs"
                  "unstable=/etc/nix/inputs/unstable"
                ];

                nix.settings = {
                  substituters = [ "https://hyprland.cachix.org" ];
                  trusted-substituters = [ "https://hyprland.cachix.org" ];
                  trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
                };
              }
            ];
          };
        }) hosts
      );

    };
}
