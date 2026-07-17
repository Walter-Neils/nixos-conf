{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  users.groups.bluetooth = {};
  users.groups.pipewire = {};
  services.blueman.enable = true;
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
