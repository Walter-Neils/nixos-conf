{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let 
  winePackage = pkgs.wineWow64Packages.stable;
in
{
  environment.systemPackages = [
    winePackage
  ];

  boot.binfmt.registrations."DOSWin" = {
    interpreter = "${winePackage}/bin/wine";
    recognitionType = "magic";
    magicOrExtension = "MZ";
    offset = 0;
    wrapInterpreterInShell = false;
  };
}
