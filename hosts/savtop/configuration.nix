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
    ../../modules/users/william.nix
    ./hardware-configuration.nix
    ../../modules/tweaks/autologin.nix
    ../../modules/tweaks/auto-update.nix
    ../../modules/config/audio.nix
    ../../modules/program-groups/gaming.nix
    ../../modules/program-groups/standard-gui.nix
    ../../modules/program-groups/windows-compat.nix
    ../../modules/program-groups/pro-audio.nix
    ../../modules/programs/tailscale.nix
    ../../modules/programs/spotify.nix
    ../../modules/programs/kde-plasma.nix
  ];

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.05"; # Did you read the comment?
}
