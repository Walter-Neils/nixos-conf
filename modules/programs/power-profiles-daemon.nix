
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  services.power-profiles-daemon.enable = true;
}
