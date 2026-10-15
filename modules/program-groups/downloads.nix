{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/qbittorrent.nix
  ];

  assertions = [
    {
      assertion = config.win.isSystemGraphical;
      message = "The 'downloads' program group requires a graphical system (win.isSystemGraphical = true).";
    }
  ];
}
