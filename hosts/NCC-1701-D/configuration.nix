{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./custom-mounts.nix
    ./hardware-configuration.nix
    ../../modules/users/walterineils.nix
    ../../modules/config/bluetooth.nix
    ../../modules/programs/greetd.nix
    ../../modules/tweaks/autologin.nix
    ../../modules/tweaks/headless-streamer.nix
    ../../modules/tweaks/platformio.nix
    ../../modules/program-groups/cryptography.nix
    ../../modules/program-groups/game-emulators.nix
    ../../modules/program-groups/desktop.nix
    ../../modules/program-groups/browsing.nix
    ../../modules/program-groups/app-distribution.nix
    ../../modules/program-groups/containers.nix
    ../../modules/program-groups/remote-play.nix
    ../../modules/program-groups/gaming.nix
    ../../modules/program-groups/gpu-tools.nix
    ../../modules/program-groups/communication.nix
    ../../modules/program-groups/windows-compatibility.nix
    ../../modules/program-groups/audio.nix
    ../../modules/program-groups/development.nix
    ../../modules/program-groups/networking.nix
    ../../modules/program-groups/virtualisation.nix
    ../../modules/program-groups/local-ai.nix
    ../../modules/program-groups/remote-shell.nix
    ../../modules/program-groups/vpn.nix
    ../../modules/program-groups/media.nix

    ../../modules/programs/hyprland.nix
    ../../modules/program-groups/office.nix
  ];


  virtualisation.vmVariant = {
    # For faster boot, avoid waiting for ARP on the virtual NIC.
    networking.dhcpcd.extraConfig = lib.mkForce "noarp";
  };
  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
