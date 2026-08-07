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
  virtualisation.lxc = {
    enable = true;
    systemConfig = ''
      lxc.lxcpath = /var/lib/lxc
    '';
  };
  boot.kernelModules = [ "uinput" ];
  services.udev.extraRules = ''
    	  KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
    	  '';

  environment.systemPackages = with pkgs; [
    lxc
    ebtables
    dnsmasq
  ];
}
