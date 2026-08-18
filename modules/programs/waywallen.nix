{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  waywallen = pkgs.appimageTools.wrapType2 {
    pname = "waywallen";
    version = "0.3.5";
    src = pkgs.fetchurl {
      url = "https://github.com/waywallen/waywallen/releases/download/v0.3.5/waywallen-0.3.5-x86_64.AppImage";
      hash = "sha256-As2cUqBYhjjECtdLEZcKbvtwou10NCD/kRajIwe6W9U=";
      executable = true;
    };
  };
in
{
  environment.systemPackages = [
    waywallen
  ];
}
