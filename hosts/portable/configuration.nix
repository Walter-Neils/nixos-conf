{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/users/public.nix
    ../../modules/config/bluetooth.nix
    ../../modules/graphics/intel.nix
    ../../modules/graphics/nvidia-legacy.nix
    ../../modules/programs/kde-plasma.nix
    ../../modules/programs/sddm/default.nix
    ../../modules/tweaks/autologin.nix
    ../../modules/program-groups/desktop.nix
    ../../modules/program-groups/cli.nix
    ../../modules/program-groups/browsing.nix
    ../../modules/program-groups/app-distribution.nix
    ../../modules/program-groups/gaming.nix
    ../../modules/program-groups/windows-compatibility.nix
    ../../modules/program-groups/audio.nix
    ../../modules/program-groups/media.nix
    ../../modules/program-groups/communication.nix
  ];

  # common.nix hardcodes the Intel VA-API driver. This system can boot on AMD,
  # Intel and NVIDIA hardware, so let libva autodetect the driver instead.
  environment.sessionVariables.LIBVA_DRIVER_NAME = lib.mkForce null;

  hardware.graphics.extraPackages = with pkgs; [
    nvidia-vaapi-driver
  ];

  # NixOS user activation runs from the initrd, before the tmpfs on /home is
  # mounted, so the home directory it creates is hidden by the tmpfs. Recreate
  # it in stage 2, after local-fs.target has mounted /home.
  systemd.tmpfiles.rules = [
    "d /home/public 0700 public users -"
  ];

  services.displayManager.sddm.wayland.enable = true;

  services.upower.enable = true;
  zramSwap.enable = true;

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
