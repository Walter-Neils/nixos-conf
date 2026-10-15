{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  config = lib.mkIf config.win.isSystemGraphical {
    programs.virt-manager.enable = true;
  };
}
