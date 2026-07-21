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
    ../../modules/program-groups/encryption.nix
    ../../modules/program-groups/standard-gui.nix
    ../../modules/program-groups/windows-compat.nix
    ../../modules/program-groups/pro-audio.nix
    ../../modules/program-groups/development.nix
    ../../modules/program-groups/virtualisation.nix

    ../../modules/programs/docker.nix
    ../../modules/programs/tailscale.nix
    ../../modules/programs/spotify.nix
    ../../modules/programs/hyprland.nix
  ];

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
