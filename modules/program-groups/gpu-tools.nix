{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/lact.nix
    ../programs/lsfg-vk.nix
    ../programs/gpu-screen-recorder.nix
  ];
}
