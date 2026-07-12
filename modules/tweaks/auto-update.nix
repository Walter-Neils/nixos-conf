{
  pkgs,
  inputs,
  config,
  ...
}:
{
  systemd.services.win-update = {
    description = "Auto-update the NixOS install";
    after = [ "network.target" ];
    wantedBy = [ ];

    path = with pkgs; [
      nixos-rebuild
      nix # Needed by nixos-rebuild
      git # Needed to fetch github: flakes
      openssh # Needed if your github fetch uses SSH keys
    ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "win-autoupdate" ''
        #!/usr/bin/env bash
        HOSTNAME=$(cat /etc/hostname)
        nixos-rebuild boot --refresh --flake github:Walter-Neils/nixos-conf#$HOSTNAME
      ''}";
    };
  };
  systemd.timers.win-update = {
    description = "Trigger win-update service every 12 hours";
    wantedBy = [ "timers.target" ]; # Starts the timer on boot
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "6h";
      RandomizedDelaySec = "15m";
    };
  };
}
