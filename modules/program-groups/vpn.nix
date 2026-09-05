{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/protonvpn.nix
    ../programs/qbittorrent.nix
  ];
}
