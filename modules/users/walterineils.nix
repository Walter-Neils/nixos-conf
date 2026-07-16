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
    ];
    shell = pkgs.unstable.fish;
  };
  win.autologin.user = lib.mkDefault "walterineils";
}
