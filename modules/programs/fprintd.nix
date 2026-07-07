{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  # Enroll fingerprints with fprintd-enroll $USER
  services.fprintd.enable = true;
}
