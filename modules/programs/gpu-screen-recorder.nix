{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  gsr-ui-pkg = inputs.gsr-ui.packages.${pkgs.stdenv.hostPlatform.system}.gpu-screen-recorder-ui;
in
{
  imports = [
    inputs.gsr-ui.nixosModules.default
  ];

  programs.gpu-screen-recorder = {
    package = inputs.gsr-ui.packages.${pkgs.stdenv.hostPlatform.system}.gpu-screen-recorder;
    enable = true;
    ui.enable = true;
  };

  systemd.user.services.gpu-screen-recorder-ui = {
    description = "GPU Screen Recorder UI (ShadowPlay Overlay)";

    after = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];

    environment = { };

    serviceConfig = {
      # Use the explicit package path we extracted above
      ExecStart = "${gsr-ui-pkg}/bin/gsr-ui";

      Environment = [
        "PATH=${gsr-ui-pkg}/bin:/run/current-system/sw/bin"
      ];

      Restart = "on-failure";
      RestartSec = "3";
    };
  };
}
