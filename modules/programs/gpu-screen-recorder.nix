{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.gsr-ui.nixosModules.default
  ];

  programs.gpu-screen-recorder = {
    package = inputs.gsr-ui.packages.${pkgs.stdenv.hostPlatform.system}.gpu-screen-recorder;
    enable = true;
    ui.enable = true;
  };
}
