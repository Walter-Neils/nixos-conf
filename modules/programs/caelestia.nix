{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  caelestia-shell = (
    inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      inherit hyprland;
    }
  );
in
{
  environment.systemPackages = [
    caelestia-shell
  ];

  systemd.user.services.caelestia = {
    description = "Caelestia Desktop Shell";
    
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${caelestia-shell}/bin/caelestia-shell"; 
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
