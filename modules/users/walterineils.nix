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
  users.groups.plugdev = { };
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
      "render"
      "pipewire"
      "libvirtd"
    ];
    shell = pkgs.fish;
  };
  win.autologin.user = lib.mkDefault "walterineils";
}
