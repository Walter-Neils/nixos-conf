{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/tweaks/autologin.nix
    ../../modules/program-groups/game-streaming.nix
    ../../modules/program-groups/gaming.nix
    ../../modules/program-groups/windows-compat.nix
    ../../modules/programs/tailscale.nix
  ];

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
