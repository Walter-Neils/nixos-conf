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
  services.pipewire.systemWide = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "10-bluez" = {
          "monitor.bluez.properties" = {
            "bluez5.roles" = [
              "a2dp_sink"
              "a2dp_source"
              "hfp_hf"
              "hfp_ag"
              "hsp_hs"
              "hsp_ag"
            ];
          };
          "wireplumber.profiles" = {
            "main" = {
              "monitor.bluez" = "required";
            };
          };
        };
      };
    };
  };
}
