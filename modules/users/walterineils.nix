{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
{
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
    ];
    shell = pkgs.unstable.fish;
  };
  win.autologin.user = lib.mkDefault "walterineils";
}
