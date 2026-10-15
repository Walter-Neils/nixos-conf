{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/distrobox.nix
    ../programs/docker.nix
  ];
}
