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
    ];
    shell = pkgs.unstable.fish;
  };
  win.autologin.user = lib.mkDefault "walterineils";
}
