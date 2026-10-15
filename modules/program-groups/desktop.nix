{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/waywallen.nix
  ];

  assertions = [
    {
      assertion = config.win.isSystemGraphical;
      message = "The 'desktop' program group requires a graphical system (win.isSystemGraphical = true).";
    }
  ];
}
