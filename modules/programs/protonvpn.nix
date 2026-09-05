{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    proton-vpn
  ];

  services.expressvpn.enable = true;
}
