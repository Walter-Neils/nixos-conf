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
  services.power-profiles-daemon.enable = true;

  environment.systemPackages = [
    caelestia-shell
  ];
}
