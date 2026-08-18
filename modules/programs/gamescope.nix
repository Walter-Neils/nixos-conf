{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.steam = {
    gamescopeSession.enable = true;
  };
}
