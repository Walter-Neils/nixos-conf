{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/onlyoffice.nix
    ../programs/qalculate.nix
    ../programs/zenity.nix
  ];

  assertions = [
    {
      assertion = config.win.isSystemGraphical;
      message = "The 'office' program group requires a graphical system (win.isSystemGraphical = true).";
    }
  ];
}
