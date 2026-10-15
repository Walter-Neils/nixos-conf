{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/flatpak.nix
    ../programs/bazaar.nix
  ];
}
