{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
    services = {
        desktopManager.plasma6.enable = true;
    };
}
