{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/waywallen.nix
    ../programs/flatpak.nix
    ../programs/firefox.nix
    ../programs/pipewire.nix
  ];
}
