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
