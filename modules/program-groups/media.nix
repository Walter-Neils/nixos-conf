{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/vlc.nix
    ../programs/spotify.nix
    ../programs/tidal.nix
  ];
}
