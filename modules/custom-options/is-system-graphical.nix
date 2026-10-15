{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
{
  options.win.isSystemGraphical = lib.mkOption {
    type = lib.types.bool;
    description = "Indicates whether or not the system installation is graphical.";
    default = true;
  };
}
