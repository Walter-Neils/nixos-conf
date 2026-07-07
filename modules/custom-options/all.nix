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
  ];
}
