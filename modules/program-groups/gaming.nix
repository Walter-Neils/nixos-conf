{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../tweaks/star-citizen.nix
    ../programs/steam.nix
    ../programs/prismlauncher.nix
    ../programs/lutris.nix
    ../programs/r2modman.nix
    ../programs/protonup-qt.nix
    ../programs/protontricks.nix
    ../programs/amethyst.nix
    ../programs/gamescope.nix
  ];

  assertions = [
    {
      assertion = config.win.isSystemGraphical;
      message = "The 'gaming' program group requires a graphical system (win.isSystemGraphical = true).";
    }
  ];
}
