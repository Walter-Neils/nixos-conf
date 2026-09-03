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

  # Allow GitHub Actions workflows (running as gh-runner) trusted nix-daemon
  # features such as --impure, nixos-rebuild and --no-sandbox.
  nix.settings.trusted-users = [
    "root"
    "@wheel"
    "gh-runner"
  ];

  # services.logind.settings.Login.HandleLidSwitch = "suspend";
  # services.logind.settings.Login.HandleLidSwitchDocked = "suspend";
  services.upower.enable = true;

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?

  virtualisation.vmVariant = {
    # For faster boot, avoid waiting for ARP on the virtual NIC.
    networking.dhcpcd.extraConfig = lib.mkForce "noarp";
    virtualisation = {
      memorySize = 16384;
      cores = 24; # Keep 8 cores completely free for the host
      diskSize = 50000; # 50GB ish
    };
  };
}
