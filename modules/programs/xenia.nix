{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    xenia-canary
  ];
}
