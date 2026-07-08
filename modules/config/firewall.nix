{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  networking.firewall.enable = true;
  networking.firewall = {
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };
}
