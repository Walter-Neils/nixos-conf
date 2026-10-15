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
    ../../modules/users/kamikaze.nix
    ./hardware-configuration.nix
    ../../modules/config/bluetooth.nix
    ../../modules/program-groups/development.nix
    ../../modules/program-groups/networking.nix
    ../../modules/program-groups/game-emulators.nix
    ../../modules/program-groups/local-ai.nix
    ../../modules/tweaks/autologin.nix
    ../../modules/tweaks/auto-update.nix
    ../../modules/program-groups/gaming.nix
    ../../modules/program-groups/gpu-tools.nix
    ../../modules/program-groups/communication.nix
    ../../modules/program-groups/desktop.nix
    ../../modules/program-groups/browsing.nix
    ../../modules/program-groups/app-distribution.nix
    ../../modules/program-groups/containers.nix
    ../../modules/program-groups/windows-compatibility.nix
    ../../modules/program-groups/audio.nix
    ../../modules/program-groups/vpn.nix
    ../../modules/program-groups/media.nix
    ../../modules/programs/tailscale.nix
    ../../modules/programs/kde-plasma.nix
  ];

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
