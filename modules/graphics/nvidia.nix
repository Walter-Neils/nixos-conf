{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  # The NVIDIA 595.71.05 shipped in nixos-26.05 does not compile against
  # linux-zen 7.2.9: nvidia/os-interface.c calls strncpy() without including
  # <string.h>, which the kernel no longer pulls in transitively. NVIDIA fixed
  # this in 595.104.02 by switching to strscpy(). Use that version, built via
  # mkDriver so it still matches the kernel configured in modules/common.nix.
  nvidiaDriver = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "595.104.02";
    sha256_64bit = "sha256-5CHCAuTHn1jDx/MWG75xRU67PYiTb4ggWg4yfNBMWco=";
    sha256_aarch64 = "sha256-PafStmwNMufeDp3VtpTGGCoW+53Gor/mieO1m1pI7gI=";
    openSha256 = "sha256-FWk5ra2yjz8VAxAA8GXrSoeBj/XC1BKvsKsBKR09joE=";
    settingsSha256 = "sha256-4Kxro6tvI5aX4nu2RspgyBsW+Jq3/VYjSAS5UGdzTCU=";
    persistencedSha256 = "sha256-JsMLPqJuZwAtHngsQODMsmgO7F2tVkQ2arc7fYa2bwo=";
  };
in
{
  services.xserver.videoDrivers = [ "nvidia" ];

  # Use NVIDIA's closed-source (proprietary) kernel modules. The open kernel
  # modules (hardware.nvidia.open = true) fail to build against linux-zen 7.2.9.
  hardware.nvidia.open = false;
  hardware.nvidia.package = nvidiaDriver;
}
