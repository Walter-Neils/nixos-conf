{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  users.groups.pipewire = {};
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
    };
  };
}
