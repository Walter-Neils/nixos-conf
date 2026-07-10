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
    ./memory-limits/browser.nix
  ];
}
