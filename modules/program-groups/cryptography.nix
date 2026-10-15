{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ];

  environment.systemPackages = with pkgs; [
    libargon2
  ];
}
