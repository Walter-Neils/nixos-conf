{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  # Enable the LACT daemon and install the package
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];
  environment.systemPackages = with pkgs; [ lact ];

  # Required for Overclocking / Fan Control / Power Profile adjustments:
  # Sets the amdgpu ppfeaturemask bitmask (0xffffffff enables all Overdrive features)
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
}
