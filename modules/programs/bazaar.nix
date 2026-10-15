{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.win.isSystemGraphical {
    assertions = [
      {
        assertion = config.services.flatpak.enable;
        message = "Bazaar requires flatpak";
      }
    ];

    services.flatpak.packages = [
      "io.github.kolunmi.Bazaar"
    ];
  };
}
