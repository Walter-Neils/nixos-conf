{
  config,
  lib,
  pkgs,
  inputs,
  options,
  ...
}:
{
  imports = [ ../programs/github-actions-runner.nix ];
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
  services.custom-github-runner.enable = true;
  services.custom-github-runner.user = "gh-runner";
}
