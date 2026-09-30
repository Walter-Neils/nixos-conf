{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./github.nix ];
  programs.git.enable = true;
}
