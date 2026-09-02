{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/users/gh-runner.nix
    ../../modules/users/public.nix
    ./hardware-configuration.nix
    ../../modules/programs/docker.nix
    ../../modules/program-groups/encryption.nix
    ../../modules/programs/tailscale.nix
    ../../modules/programs/lemurs.nix
    ../../modules/programs/github.nix
    ../../modules/programs/github-actions-runner.nix
  ];

  services.logind.lidSwitch = "ignore";

  # services.logind.settings.Login.HandleLidSwitch = "suspend";
  # services.logind.settings.Login.HandleLidSwitchDocked = "suspend";
  services.upower.enable = true;

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?

  virtualisation.vmVariant = {
    # For faster boot, avoid waiting for ARP on the virtual NIC.
    networking.dhcpcd.extraConfig = lib.mkForce "noarp";
  };
}
