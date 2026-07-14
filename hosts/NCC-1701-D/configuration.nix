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
    ../../modules/tweaks/autologin.nix
    ../../modules/tweaks/auto-update.nix
    ../../modules/program-groups/standard-gui.nix
    ../../modules/program-groups/game-streaming.nix
    ../../modules/program-groups/gaming.nix
    ../../modules/program-groups/windows-compat.nix
    ../../modules/program-groups/pro-audio.nix
    ../../modules/program-groups/development.nix

    ../../modules/programs/docker.nix
    ../../modules/programs/tailscale.nix
    ../../modules/programs/spotify.nix
    ../../modules/programs/tidal.nix
    ../../modules/programs/hyprland.nix
  ];

  nix.settings.trusted-users = [
    "root"
    "nix-builder"
  ];
  users.users.nix-builder = {
    isSystemUser = true;
    group = "nix-builder";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlF2W/sDiB00cUz69CLp10AJ+AFYJYh/JcMvxwfO+43 root@NCC-1701-D"
    ];
  };
  users.groups.nix-builder = { };

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
