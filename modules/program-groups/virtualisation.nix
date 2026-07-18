{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/libvirtd.nix
    ../programs/virt-manager.nix
  ];

  environment.systemPackages = with pkgs; [ ];
}
