{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # Lutris runs games inside its own bubblewrap FHS chroot, so nix-ld (which
    # normally supplies missing libs from the host) is never consulted. The
    # nixpkgs FHS env ships nss but not nspr, and omits libXdamage; anything
    # linking libcef.so (e.g. BeamNG.drive native) fails on those two.
    (lutris.override {
      extraPkgs = p: [
        p.nspr
        p.libxdamage
      ];
    })
  ];
}
