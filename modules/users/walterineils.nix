{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
{
  imports = [
    ../themes/gtk/kanagawa.nix
  ];
  users.groups.plugdev = {};
  users.groups.bluetooth = {};
  users.groups.pipewire = {};
  users.users.walterineils = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "networkmanager"
      "sudo"
      "docker"
      "podman"
      "dialout"
      "uinput"
      "seat"
      "plugdev"
      "bluetooth"
      "video"
      "pipewire"
    ];
    shell = pkgs.unstable.fish;
  };
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
        # Force wireplumber 0.5 to parse and explicitly register the bluez monitor
        "10-bluez" = {
          "monitor.bluez.properties" = {
            "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "hfp_hf" "hfp_ag" "hsp_hs" "hsp_ag" ];
          };
          # Explicitly force the bluez5 backend loading
          "wireplumber.profiles" = {
            "main" = {
              "monitor.bluez" = "required";
            };
          };
        };
      };
    };
  };
  win.autologin.user = lib.mkDefault "walterineils";
}
