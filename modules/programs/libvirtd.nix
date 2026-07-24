{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "virbr0" ];
  };

  environment.systemPackages = with pkgs; [
    lxc
    ebtables
    dnsmasq
  ];
}
