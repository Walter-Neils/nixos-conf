{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  hardware.bluetooth.enable = true;
  users.groups.bluetooth = {};
  services.blueman.enable = true;
}
