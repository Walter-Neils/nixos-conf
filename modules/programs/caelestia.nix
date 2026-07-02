{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  # 1. Enable the system daemon so the DBus interfaces exist
  services.power-profiles-daemon.enable = true;

  # 2. Add the wrapped package to the system profile
  environment.systemPackages = [
    (inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (oldAttrs: {
      nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
      postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/caelestia-shell \
          --prefix PATH : ${lib.makeBinPath [ pkgs.power-profiles-daemon ]}
      '';
    }))
  ];
}
