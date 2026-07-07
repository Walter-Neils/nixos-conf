{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/sunshine.nix
    ../programs/moonlight.nix
  ];
}
