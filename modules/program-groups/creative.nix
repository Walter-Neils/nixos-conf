{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/blender.nix
  ];

  assertions = [
    {
      assertion = config.win.isSystemGraphical;
      message = "The 'creative' program group requires a graphical system (win.isSystemGraphical = true).";
    }
  ];
}
