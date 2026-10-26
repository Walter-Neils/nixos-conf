{
  lib,
  pkgs,
  ...
}:
let
  iiSddmTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "ii-sddm-theme";
    version = "0.6-unstable-2026-06-02";

    src = pkgs.fetchFromGitHub {
      owner = "3d3f";
      repo = "ii-sddm-theme";
      rev = "1d4bcb66647f750bcc14d73de025eae8dd1e3db7";
      hash = "sha256-07Es1f7a4ow3x5f0sh9tYtgnjmhIcV+zib5ZUNkF2nU=";
    };

    dontWrapQtApps = true;

    propagatedBuildInputs = with pkgs.kdePackages; [
      qt5compat
      qtimageformats
      qtmultimedia
      qtsvg
      qtvirtualkeyboard
    ];

    installPhase = ''
      themeDir=$out/share/sddm/themes/ii-sddm-theme
      mkdir -p "$themeDir"

      cp -r \
        Assets \
        Backgrounds \
        Components \
        Main.qml \
        Previews \
        Themes \
        metadata.desktop \
        LICENSE \
        "$themeDir/"

      # Standalone defaults for the no-Matugen mode.
      cp noMatugen/Colors.qml "$themeDir/Components/Colors.qml"
      cp noMatugen/Settings.qml "$themeDir/Components/Settings.qml"
      cp noMatugen/background.png "$themeDir/Backgrounds/background.png"

      mkdir -p "$out/share/fonts/ii-sddm-theme-fonts"
      find fonts/ii-sddm-theme-fonts -type f \
        \( -name '*.ttf' -o -name 'LICENSE' -o -name 'NOTICE' -o -name 'OFL.txt' \) \
        -exec cp {} "$out/share/fonts/ii-sddm-theme-fonts/" \;
    '';

    meta = {
      description = "SDDM theme based on the ii lockscreen";
      homepage = "https://github.com/3d3f/ii-sddm-theme";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.linux;
    };
  };
in
{
  imports = [ ../default.nix ];

  services.displayManager.sddm = {
    theme = "ii-sddm-theme";

    extraPackages = with pkgs.kdePackages; [
      qt5compat
      qtimageformats
      qtmultimedia
      qtsvg
      qtvirtualkeyboard
    ];

    settings.General = {
      InputMethod = "qtvirtualkeyboard";
      GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell QT_IM_MODULE=qtvirtualkeyboard QML2_IMPORT_PATH=/run/current-system/sw/share/sddm/themes/ii-sddm-theme/Components";
    };
  };

  environment.systemPackages = [ iiSddmTheme ];
  fonts.packages = [ iiSddmTheme ];
}
