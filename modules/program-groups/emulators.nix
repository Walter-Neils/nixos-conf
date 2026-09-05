{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/ryubing.nix
    ../program/xemu.nix
  ];
}
