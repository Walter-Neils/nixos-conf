{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/ryubing.nix
    ../programs/xemu.nix
    ../programs/xenia.nix
  ];

  assertions = [
    {
      assertion = config.win.isSystemGraphical;
      message = "The 'game-emulators' program group requires a graphical system (win.isSystemGraphical = true).";
    }
  ];
}
