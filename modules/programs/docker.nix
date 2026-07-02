{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  virtualisation.docker = {
    enable = true;
  };
}
