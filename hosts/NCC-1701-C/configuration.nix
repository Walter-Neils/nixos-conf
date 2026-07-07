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
    ../../modules/graphics/intel.nix
    ../../modules/graphics/nvidia.nix
    ../../modules/program-groups/game-streaming.nix
    ../../modules/program-groups/gaming.nix
    ../../modules/program-groups/windows-compat.nix
    ../../modules/program-groups/pro-audio.nix
    ../../modules/programs/tailscale.nix
    ../../modules/programs/spotify.nix
    ../../modules/programs/tidal.nix
    ../../modules/tweaks/fingerprint-sudo.nix
    ../../modules/programs/kde-plasma.nix
  ];

  # Commit test

  services.logind.settings.Login.HandleLidSwitch = "suspend";
  services.logind.settings.Login.HandleLidSwitchDocked = "suspend";
  services.upower.enable = true;

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
