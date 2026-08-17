{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    ollama-vulkan
  ];
  services.ollama.enable = true;
}
