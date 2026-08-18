{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  version = "0.3.5";
  src = pkgs.fetchurl {
    url = "https://github.com/waywallen/waywallen/releases/download/v${version}/waywallen-${version}-x86_64.AppImage";
    hash = "sha256-As2cUqBYhjjECtdLEZcKbvtwou10NCD/kRajIwe6W9U=";
    executable = true;
  };
  icon = pkgs.fetchurl {
    url = "https://github.com/waywallen/waywallen/raw/main/ui/assets/waywallen-ui.svg";
    hash = "sha256-/Z/sjjjjelDL3M3Y2IRCxDs1DFAfumuE0MyqfRX2b2E=";
  };
  appimageContents = pkgs.appimageTools.extract {
    pname = "waywallen";
    inherit version src;
  };
  waywallen = pkgs.symlinkJoin {
    name = "waywallen-${version}";
    paths = [
      (pkgs.appimageTools.wrapType2 {
        pname = "waywallen";
        inherit version src;
        extraPkgs = pkgs: [ pkgs.lz4 ];
      })
      (pkgs.runCommand "waywallen-desktop" { } ''
        mkdir -p $out/share/applications $out/share/icons/hicolor/scalable/apps
        cp ${appimageContents}/org.waywallen.waywallen.desktop $out/share/applications/
        cp ${icon} $out/share/icons/hicolor/scalable/apps/org.waywallen.waywallen.svg
      '')
    ];
  };
in
{
  environment.systemPackages = [
    waywallen
  ];
}
