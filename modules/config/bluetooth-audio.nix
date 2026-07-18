{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ../programs/pipewire.nix ];
  hardware.bluetooth.enable = true;
  users.groups.bluetooth = {};
  services.blueman.enable = true;
  services.pipewire.systemWide = true;
  services.pipewire = {
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

  services.pipewire.wireplumber.extraConfig = {
    "bluetooth" = {
      "monitor.bluez.properties" = {
        "bluez5.codecs" = [
          "sbc"
          "sbc_xq"
          "aac"
          "aptx"
          "aptx_hd"
        ];
      };
    };
  };
}
