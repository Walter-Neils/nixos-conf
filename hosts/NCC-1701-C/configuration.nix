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
    ../../modules/programs/docker.nix
    ../../modules/graphics/intel.nix
    ../../modules/graphics/nvidia.nix
    ../../modules/program-groups/standard-gui.nix
    ../../modules/program-groups/encryption.nix
    ../../modules/program-groups/game-streaming.nix
    ../../modules/program-groups/gaming.nix
    ../../modules/program-groups/windows-compat.nix
    ../../modules/program-groups/pro-audio.nix
    ../../modules/program-groups/development.nix
    ../../modules/programs/tailscale.nix
    ../../modules/programs/spotify.nix
    ../../modules/programs/tidal.nix
    ../../modules/programs/qalculate.nix
    ../../modules/programs/qbittorrent.nix
    ../../modules/programs/lemurs.nix
    ../../modules/tweaks/fingerprint-sudo.nix
    ../../modules/tweaks/auto-update.nix
  ];

# /etc/nixos/configuration.nix

services.udev.extraRules = ''
  # 1. Native Google Android Auto Accessory Handoff
  SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="2d00", MODE="0666", GROUP="plugdev"
  SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="2d01", MODE="0666", GROUP="plugdev"

  # 2. Catch-all for any Android Device flipping to Accessory Mode
  SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="18d1", MODE="0666", GROUP="plugdev"

  # 3. Handle specific vendor handoffs (Samsungs, Pixels, LGs) before/during transition
  SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="plugdev"
  SUBSYSTEM=="usb", ATTR{idVendor}=="05c6", MODE="0666", GROUP="plugdev"
  SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", MODE="0666", GROUP="plugdev"
  SUBSYSTEM=="usb", ATTR{idVendor}=="1bbb", MODE="0666", GROUP="plugdev"
  SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", MODE="0666", GROUP="plugdev"
'';

  # services.logind.settings.Login.HandleLidSwitch = "suspend";
  # services.logind.settings.Login.HandleLidSwitchDocked = "suspend";
  services.upower.enable = true;

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
