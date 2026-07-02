{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  hardware.graphics = {
    enable = true;
    package = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.mesa;
    enable32Bit = true;
    package32 =
      inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pkgsi686Linux.mesa;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
    extraPackages32 = with pkgs; [
      intel-vaapi-driver
    ];
  };
}
