{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;
  hardware.steam-hardware.enable = true;
  services.udev.packages = [ pkgs.game-devices-udev-rules ];

  systemd.user.services.steam = {
    description = "Steam Client";

    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";

      ExecStart = "${pkgs.steam}/bin/steam -silent";

      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
