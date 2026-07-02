{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
    extraPackages32 = with pkgs; [
      intel-vaapi-driver
    ];
  };
}
