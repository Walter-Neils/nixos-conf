{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;  # see the note above
}
