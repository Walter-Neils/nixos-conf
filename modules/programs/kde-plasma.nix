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

    win.autologin.command = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland";
}
