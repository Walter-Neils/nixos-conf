{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    lsfg-vk
    lsfg-vk-ui
    vulkan-tools
  ];
  hardware.graphics.extraPackages = with pkgs; [ lsfg-vk ];
}
