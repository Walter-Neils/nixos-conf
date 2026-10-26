{
  config,
  lib,
  pkgs,
  ...
}:

{
  # The NVIDIA 580 series is the last branch that supports Pascal (GTX 10xx)
  # while still covering Turing (RTX 20xx). The newer 595 driver used by
  # ./nvidia.nix no longer works on the GTX 1070.
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    branch = "legacy_580";
    open = false;
    modesetting.enable = true;
  };

  # Xorg stays disabled on the portable host (Plasma runs on Wayland), so the
  # nvidia module does not add its kernel modules automatically.
  boot.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_drm"
  ];
}
