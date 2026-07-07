{
  config,
  lib,
  pkgs,
  inputs,
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
  services.greetd.autologinUser = lib.mkDefault "walterineils";
}
