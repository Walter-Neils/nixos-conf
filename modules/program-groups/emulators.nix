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
    ../programs/xemu.nix
  ];
}
