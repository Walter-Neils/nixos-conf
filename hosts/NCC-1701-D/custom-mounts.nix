{ config, lib, pkgs, ... }:

{
  fileSystems."/var/lib/docker" = lib.mkIf config.virtualisation.docker.enable {
    device = "/dev/mapper/root_vg-docker";
    fsType = "btrfs";
  };
}
