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
    lutris
    r2modman
  ];


  programs.steam.enable = true;

}
