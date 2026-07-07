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
  ];

  environment.systemPackages = with pkgs; [
    steam
    lutris
    r2modman
  ];

  programs.steam.enable = true;
}
