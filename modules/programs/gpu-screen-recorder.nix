{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # gsr-ui >= 93a5433 fetches this with `builtins.fetchGit { fetchSubmodules = true; }`,
  # but Nix 2.24+ dropped `fetchSubmodules` from the git scheme (renamed to `submodules`).
  # Re-declare the package so the fetch uses the supported attribute.
  gpu-screen-recorder-notification = pkgs.stdenv.mkDerivation (finalAttrs: {
    name = "gpu-screen-recorder-notification";
    version = "1.3.6";

    src = builtins.fetchGit {
      url = "https://repo.dec05eba.com/gpu-screen-recorder-notification";
      rev = "54bc6c8f139a5ff4025a4585d01c9e3f23894b72";
      submodules = true;
    };

    nativeBuildInputs = with pkgs; [
      makeWrapper
      pkg-config
      meson
      ninja
      wrapGAppsHook3
      cmake
    ];

    buildInputs = with pkgs; [
      gsettings-desktop-schemas
      libxkbcommon
      freetype
      glib
      pango
      libX11
      libXext
      libXrandr
      libXrender
      wayland
      wayland-scanner
    ];

    preFixup = ''
      wrapProgram $out/bin/gsr-notify \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            pkgs.libglvnd
            pkgs.addDriverRunpath.driverLink
          ]
        }
    '';

    meta = {
      description = "Notification overlay for gpu-screen-recorder-ui.";
      homepage = "https://git.dec05eba.com/gpu-screen-recorder-notification/about/";
      license = lib.licenses.gpl3Only;
      mainProgram = "gsr-notify";
      platforms = [ "x86_64-linux" ];
    };
  });

  # Swap in the fixed notification package so the UI's PATH wrapper resolves it.
  gsr-ui-pkg =
    inputs.gsr-ui.packages.${pkgs.stdenv.hostPlatform.system}.gpu-screen-recorder-ui.override {
      gpu-screen-recorder-notification = gpu-screen-recorder-notification;
    };
in
{
  imports = [
    inputs.gsr-ui.nixosModules.default
  ];

  programs.gpu-screen-recorder = {
    package = inputs.gsr-ui.packages.${pkgs.stdenv.hostPlatform.system}.gpu-screen-recorder;
    enable = true;
    ui = {
      enable = true;
      package = gsr-ui-pkg;
      notificationPackage = lib.mkDefault gpu-screen-recorder-notification;
    };
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