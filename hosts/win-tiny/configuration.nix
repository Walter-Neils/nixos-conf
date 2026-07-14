{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/users/walterineils.nix
    ./hardware-configuration.nix
    ../../modules/programs/hyprland.nix
    ../../modules/graphics/intel.nix
    ../../modules/program-groups/standard-gui.nix
    ../../modules/program-groups/pro-audio.nix
    ../../modules/programs/tailscale.nix
    ../../modules/programs/spotify.nix
    ../../modules/programs/tidal.nix
    ../../modules/tweaks/auto-update.nix
  ];

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "NCC-1701-D";
      system = "x86_64-linux";
      sshUser = "nix-builder";
      sshKey = "/root/.ssh/id_build_server";
      maxJobs = 16;
      speedFactor = 8;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
    }
  ];

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
