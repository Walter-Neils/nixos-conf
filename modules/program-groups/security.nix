{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/opensnitch.nix
    ../programs/firejail.nix
  ];
}
