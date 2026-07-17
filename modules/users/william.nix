{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
{
  users.users.william = {
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
    ];
    shell = pkgs.unstable.fish;
  };
  win.autologin.user = "william";
}
