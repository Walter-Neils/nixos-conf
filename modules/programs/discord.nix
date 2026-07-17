{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  flatpakEnabled = config.services.flatpak.enable;
in
{
  config = {
    environment.systemPackages = lib.mkIf (!flatpakEnabled) [
      pkgs.discord
    ];

    services.flatpak.packages = lib.mkIf flatpakEnabled [
      "com.discordapp.Discord"
    ];

    services.flatpak.overrides = lib.mkIf flatpakEnabled {
      "com.discordapp.Discord" = {
        Context = {
          filesystems = [ "xdg-run/pipewire-0" ];
          sockets = [
            "x11"
            "wayland"
            "pulseaudio"
          ];
        };
      };
    };

    systemd.user.services.discord = {
      description = "Discord Client";

      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart =
          if flatpakEnabled then
            "${pkgs.flatpak}/bin/flatpak run com.discordapp.Discord"
          else
            "${pkgs.discord}/bin/discord";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
