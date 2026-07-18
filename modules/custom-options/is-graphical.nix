{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
{
  options.win.is-graphical = lib.mkOption {
    type = lib.types.bool;
    description = "Indicates whether or not the system installation is graphical or not";
    default = false;
  };
}
