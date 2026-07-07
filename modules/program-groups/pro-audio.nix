{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/easyeffects.nix
    ../programs/qpwgraph.nix
    ../programs/alsa-utils.nix
  ];
}
