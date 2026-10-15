{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/cloudflared.nix
    ../programs/tailscale.nix
  ];
}
