{ pkgs, inputs, ... }:
{
  imports = [ ../programs/fprintd.nix ];
  # Enroll fingerprints with fprintd-enroll $USER
  security.pam.services.sudo.fprintAuth = true;
}
