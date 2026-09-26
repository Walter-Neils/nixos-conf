{ config, lib, pkgs, ... }:
{
  config = {
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