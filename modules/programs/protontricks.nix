{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  config = {
    assertions = [
      {
        assertion = config.programs.steam.enable;
        message = "ProtonTricks requires Steam";
      }
    ];
    programs.steam.protontricks.enable = true;
  };
}
