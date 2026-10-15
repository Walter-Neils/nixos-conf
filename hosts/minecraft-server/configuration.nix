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
    ../../modules/program-groups/containers.nix
    ../../modules/program-groups/cryptography.nix
    ../../modules/program-groups/networking.nix
    ../../modules/programs/lemurs.nix
    ../../modules/program-groups/game-server.nix
  ];

  # Headless server: no display stack, so graphical program groups are disabled.
  win.isSystemGraphical = false;

  services.logind.lidSwitch = "ignore";

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  # services.logind.settings.Login.HandleLidSwitch = "suspend";
  # services.logind.settings.Login.HandleLidSwitchDocked = "suspend";
  services.upower.enable = true;

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?

  virtualisation.vmVariant = {
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.port = 25565;
        guest.port = 25565;
      }
    ];

    virtualisation = {
      memorySize = 16384;
      cores = 24; # Keep 8 cores completely free for the host
      diskSize = 50000; # 50GB ish
    };
  };
}
