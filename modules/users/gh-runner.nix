{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
{
  users.users.gh-runner = {
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
  win.autologin.user = "gh-runner";
  services.custom-github-runner.enable = true;
  services.custom-github-runner.user = "gh-runner";
}
