{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/
  ];

  environment.systemPackages = with pkgs; [
    steam
    lutris
    r2modman
  ];


  programs.steam.enable = true;

}
