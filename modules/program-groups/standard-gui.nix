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
    ../programs/firefox.nix
    ../programs/pipewire.nix
  ];
}
