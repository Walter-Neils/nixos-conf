{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./samba.nix
    ./printing.nix
    ../../modules/users/walterineils.nix
    ../../modules/program-groups/networking.nix
    ../../modules/programs/fish.nix
    ../../modules/tweaks/auto-update.nix
  ];

  # Headless NAS: no display manager or graphical program groups.
  win.isSystemGraphical = false;

  # Use the vanilla kernel rather than common.nix's Zen default.
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages;

  # This 2013 Intel DH77EB firmware only reliably boots the removable EFI
  # fallback path (\EFI\BOOT\BOOTX64.EFI). Use a removable GRUB install and
  # deliberately avoid writing EFI variables.
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub = {
    efiInstallAsRemovable = true;
    useOSProber = lib.mkForce false;
    configurationLimit = lib.mkForce 3; # 512M ESP
  };

  # Monitor the LVM RAID1 data LV.
  services.lvm.dmeventd.enable = true;

  # Preserve the existing UID/GID assignments so ownership on the ext4 data LV
  # (mostly james:ventry) remains correct.
  users.users.walterineils = {
    uid = 1000;
    group = "walterineils";
    extraGroups = [
      "ventry"
      "sambausers"
    ];
  };
  users.groups.walterineils.gid = 1000;

  users.users.james = {
    isNormalUser = true;
    uid = 1001;
    group = "james";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "storage"
      "video"
      "sambausers"
      "ventry"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH93LoHcLfFQr69sujYotCO07hAqL6L5heaXPIOjX2p1 Walter's Master SSH Key"
    ];
  };
  users.groups.james.gid = 1001;
  users.groups.sambausers.gid = 1002;
  users.groups.ventry.gid = 1003;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  services.openssh.openFirewall = true;
  services.tailscale.openFirewall = true;

  # Required for CUPS/Samba DNS-SD printer advertisement.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
      addresses = true;
    };
  };

  services.smartd.enable = true;

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
