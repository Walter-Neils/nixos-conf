{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
{
  users.users.public = {
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
      "libvirtd"
    ];
    shell = pkgs.unstable.fish;
    initialPassword = "public";
  };
  win.autologin.user = "public";
}
