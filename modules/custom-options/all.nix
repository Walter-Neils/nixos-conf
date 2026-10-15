{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./autologin.nix
    ./display-manager.nix
    ./is-system-graphical.nix
    ./memory-limits/browser.nix
  ];
}
