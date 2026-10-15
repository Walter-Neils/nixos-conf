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

  assertions = [
    {
      assertion = config.win.isSystemGraphical;
      message = "The 'media' program group requires a graphical system (win.isSystemGraphical = true).";
    }
  ];
}
