{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/steam.nix
    ../programs/prismlauncher.nix
    ../programs/lutris.nix
    ../programs/r2modman.nix
  ];
}
