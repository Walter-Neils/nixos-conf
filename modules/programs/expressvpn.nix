{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    expressvpn
  ];

  services.expressvpn.enable = true;
}
