{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./wl-clipboard.nix ];
  services = {
    desktopManager.plasma6.enable = true;
  };

  win.autologin.command = "${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland";
}
