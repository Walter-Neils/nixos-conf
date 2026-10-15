{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/protonvpn.nix
  ];

  assertions = [
    {
      assertion = config.win.isSystemGraphical;
      message = "The 'vpn' program group requires a graphical system (win.isSystemGraphical = true).";
    }
  ];
}
