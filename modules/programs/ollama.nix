{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  services.ollama = {
    enable = true;
    acceleration = "vulkan";
  };
  environment.systemPackages = with pkgs; [
    ollama
  ];
}
