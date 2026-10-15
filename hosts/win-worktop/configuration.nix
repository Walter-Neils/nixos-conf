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
    ../../modules/program-groups/cryptography.nix
    ../../modules/program-groups/desktop.nix
    ../../modules/program-groups/browsing.nix
    ../../modules/program-groups/app-distribution.nix
    ../../modules/program-groups/containers.nix
    ../../modules/program-groups/windows-compatibility.nix
    ../../modules/program-groups/audio.nix
    ../../modules/program-groups/development.nix
    ../../modules/program-groups/networking.nix
    ../../modules/program-groups/virtualisation.nix
    ../../modules/program-groups/remote-shell.nix
    ../../modules/program-groups/media.nix

    ../../modules/tweaks/platformio.nix
    ../../modules/config/bluetooth.nix

    ../../modules/programs/hyprland.nix

    ../../modules/programs/lemurs.nix
  ];

  services.logind.lidSwitch = "ignore";

  services.upower.enable = true;

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
