{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/discord.nix
  ];

  assertions = [
    {
      assertion = config.win.isSystemGraphical;
      message = "The 'communication' program group requires a graphical system (win.isSystemGraphical = true).";
    }
  ];
}
