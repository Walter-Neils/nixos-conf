{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [
    "kvm-intel"
    "dm-raid"
  ];
  boot.extraModulePackages = [ ];

  hardware.cpu.intel.updateMicrocode = true;

  # New single-disk layout created for the NixOS migration:
  #   vsi/root -> /        (64G btrfs)
  #   vsi/home -> /home    (64G btrfs)
  # The ESP is the 512M vfat partition on the same SSD.
  fileSystems."/" = {
    device = "/dev/vsi/root";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/vsi/home";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0B9C-9118";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  # The 2.7T data LV (LVM RAID1 across the removable WD Reds). It must never
  # take the NAS offline, and Samba is ordered after this mount so a missing
  # LV cannot cause the share to fall back to the root filesystem.
  fileSystems."/mnt/ventry-live_data" = {
    device = "/dev/mapper/ventry-live_data";
    fsType = "ext4";
    options = [
      "nofail"
      "noatime"
      "commit=60"
      "errors=remount-ro"
    ];
  };

  # The data VG is RAID1 on the removable WD Reds. LVM's early autoactivation
  # can miss it because dm-raid is loaded late; activate it explicitly after
  # modules-load and before Samba starts.
  systemd.services.ventry-data = {
    description = "Activate the ventry data LV";
    after = [
      "systemd-modules-load.service"
      "local-fs.target"
    ];
    before = [
      "samba-smbd.service"
      "samba-nmbd.service"
    ];
    wantedBy = [ "multi-user.target" ];

    path = [
      pkgs.lvm2
      pkgs.systemd
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      vgchange -ay ventry || true
      unit="$(systemd-escape -p --suffix=mount /mnt/ventry-live_data)"
      systemctl start "$unit" || true
      systemctl reset-failed lvm-activate-ventry.service || true
    '';
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
