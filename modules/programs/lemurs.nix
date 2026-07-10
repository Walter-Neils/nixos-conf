{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
let
  potentialSessions = with pkgs; [
    hyprland
  ];

  activeSessions = builtins.filter (
    pkg: lib.elem pkg config.environment.systemPackages
  ) potentialSessions;
in
{
  services.displayManager.lemurs = {
    enable = true;

    settings = { };
  };
  services.displayManager.sessionPackages = activeSessions;
  win.displayManager = "lemurs";
}
