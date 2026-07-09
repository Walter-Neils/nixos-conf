{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
{
  options.win.displayManager = lib.mkOption {
    type = lib.types.str;
    description = "Indicates the active display manager";
    default = "<NONE>";
  };
}
