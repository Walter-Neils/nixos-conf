{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  services.dbus.implementation = "broker";
  environment.pathsToLink = [
    "/share/dbus-1"
    "/share/wireplumber"
  ];
}
