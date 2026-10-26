{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # The system boots from a USB SSD, so stage-1 needs the USB storage stack and
  # LVM. The remaining entries cover the internal disks of the machines this
  # disk is expected to be plugged into.
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "xhci_hcd"
    "usbhid"
    "usb_storage"
    "uas"
    "sd_mod"
    "dm-mod"
    "ahci"
    "nvme"
    "thunderbolt"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Keep the USB bridge from autosuspending the boot disk.
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  fileSystems."/" = {
    device = "/dev/mapper/portable_system-root";
    fsType = "btrfs";
    options = [
      "noatime"
      "compress=zstd:3"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/94F5-9D08";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # Home directories are intentionally ephemeral.
  fileSystems."/home" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [
      "mode=0755"
      "size=25%"
    ];
  };

  swapDevices = [ ];

  # The ESP is only 256 MiB, so keep the number of installed generations small.
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub = {
    efiInstallAsRemovable = true;
    useOSProber = lib.mkForce false;
    configurationLimit = lib.mkForce 3;
  };
  boot.loader.timeout = 3;

  # Firmware for amdgpu, Intel WiFi/Bluetooth, etc.
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.cpu.intel.updateMicrocode = true;

  boot.tmp.tmpfsSize = "25%";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
