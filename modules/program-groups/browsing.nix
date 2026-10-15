{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/firefox.nix
    ../programs/google-chrome.nix
  ];
}
