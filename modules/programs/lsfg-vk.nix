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
      lsfg-vk
      lsfg-vk-ui
      vulkan-tools
    ];
    hardware.graphics.extraPackages = with pkgs; [ lsfg-vk ];
  };
}
