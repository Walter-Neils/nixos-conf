{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  config = lib.mkIf config.win.isSystemGraphical {
    environment.systemPackages = with pkgs; [
      unstable.kitty
    ];
  };
}
