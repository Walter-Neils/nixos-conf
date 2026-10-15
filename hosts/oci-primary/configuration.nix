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
    ./disko.nix
    ../../modules/programs/fail2ban.nix
    ../../modules/programs/tailscale.nix
    ../../modules/program-groups/development.nix
    ../../modules/program-groups/networking.nix
    ../../modules/users/walterineils.nix
    ../../modules/tweaks/storage-grow.nix
    ../../modules/tweaks/auto-update.nix
  ];

  # Headless server: no display stack, so graphical program groups are disabled.
  win.isSystemGraphical = false;

  # Oracle Cloud Ampere A1 instances boot UEFI and do not allow writing EFI
  # variables, so GRUB must be installed as a removable EFI app.
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  # Blank imported disk: nothing else to probe for.
  boot.loader.grub.useOSProber = lib.mkForce false;

  # Serial/VNC console for OCI console access (aarch64 uses ttyAMA0; the
  # nvme* parameters were taken from OCI's own kernel cmdline).
  boot.kernelParams = [
    "console=tty1"
    "console=ttyAMA0,115200"
    "nvme.shutdown_timeout=10"
    "nvme_core.shutdown_timeout=10"
  ];

  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "prohibit-password";
  };

  # walterineils has no password configured (key-only logins), so allow the
  # wheel group to sudo without one on this single-admin headless server.
  security.sudo.wheelNeedsPassword = false;

  # Inbound SSH so the box stays reachable from the OCI security list while
  # admin traffic moves to Tailscale. Revisit/restrict once on the tailnet.
  networking.firewall.allowedTCPPorts = [ 22 ];

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
