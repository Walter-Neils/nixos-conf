{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/users/mel.nix
    ./hardware-configuration.nix
    ../../modules/programs/kde-plasma.nix
    ../../modules/graphics/intel.nix
    ../../modules/program-groups/desktop.nix
    ../../modules/program-groups/cli.nix
    ../../modules/program-groups/browsing.nix
    ../../modules/program-groups/app-distribution.nix
    ../../modules/program-groups/containers.nix
    ../../modules/program-groups/cryptography.nix
    ../../modules/program-groups/windows-compatibility.nix
    ../../modules/program-groups/networking.nix
    ../../modules/program-groups/media.nix
    ../../modules/program-groups/office.nix
    # ../../modules/programs/lemurs.nix
    ../../modules/programs/sddm/themes/ii-sddm-theme.nix
  ];

  services.logind.lidSwitch = "ignore";

  # services.logind.settings.Login.HandleLidSwitch = "suspend";
  # services.logind.settings.Login.HandleLidSwitchDocked = "suspend";
  services.upower.enable = true;

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
