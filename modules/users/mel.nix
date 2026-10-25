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
  users.users.mel = {
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
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH93LoHcLfFQr69sujYotCO07hAqL6L5heaXPIOjX2p1 Walter's Master SSH Key"
    ];
  };
  win.autologin.user = "mel";
}
