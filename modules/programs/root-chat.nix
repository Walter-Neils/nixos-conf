# https://installer.rootapp.com/installer/Linux/X64/Root.AppImage

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://installer.rootapp.com/installer/Linux/X64/Root.AppImage";
    hash = "sha256-u+Nk8yslYr9S7cD8jG9KRIDFPelvfl7Q+FWa37nbF1c=";
    executable = true;
  };
  appimageContents = pkgs.appimageTools.extract {
    pname = "root-chat";
    inherit version src;
  };
  rootChat = pkgs.symlinkJoin {
    name = "root-chat";
    paths = [
      (pkgs.appimageTools.wrapType2 {
        pname = "root-chat";
        inherit version src;
      })
      (pkgs.runCommand "root-chat-desktop" { } ''
        mkdir -p $out/share/applications $out/share/icons/hicolor/512x512/apps
        cp ${appimageContents}/Root.desktop $out/share/applications/
        sed -i 's/^Exec=.*/Exec=root-chat/' $out/share/applications/Root.desktop
        cp ${appimageContents}/Root.png $out/share/icons/hicolor/512x512/apps/Root.png
      '')
    ];
  };
in
{
  environment.systemPackages = [
    rootChat
  ];
}