# Declarative disk layout for oci-primary (Oracle Cloud Ampere A1, aarch64).
#
# LVM strategy: the boot volume hosts a single VG (`root_vg`) with the root
# filesystem as an LV on btrfs. When the host needs more space, attach a OCI
# block volume, `pvcreate` + `vgextend root_vg` it, then run the storage-grow
# unit (or `lvextend -l +100%FREE` + `btrfs filesystem resize max /`).
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0077"
                "dmask=0077"
              ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "root_vg";
            };
          };
        };
      };
    };
    lvm_vg = {
      root_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/";
              mountOptions = [
                "compress=zstd"
              ];
            };
          };
        };
      };
    };
  };
}