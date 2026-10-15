{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/firefox.nix
    ../programs/google-chrome.nix
  ];

  assertions = [
    {
      assertion = config.win.isSystemGraphical;
      message = "The 'browsing' program group requires a graphical system (win.isSystemGraphical = true).";
    }
  ];
}
