{ pkgs, inputs, ... }:
{
  imports = [../programs/fprintd.nix];
  security.pam.services.sudo.fprintAuth = true;
}
