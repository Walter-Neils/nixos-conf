{
  pkgs,
  ...
}:
let
  sugarCandy = pkgs.stdenvNoCC.mkDerivation {
    pname = "sddm-sugar-candy";
    version = "1.6-unstable-2024-07-07";

    src = pkgs.fetchFromGitHub {
      owner = "Kangie";
      repo = "sddm-sugar-candy";
      rev = "d31dbf58286ecdcd3a490cd0c9d9ba2f15c26920";
      hash = "sha256-HMlzUyRvXvzjaeq4FDxsHZga1zsn1w2Ln7SpctqjWk8=";
    };

    dontWrapQtApps = true;

    propagatedBuildInputs = with pkgs.kdePackages; [
      qt5compat
      qtsvg
    ];

    postPatch = ''
      substituteInPlace \
        Main.qml \
        Components/Input.qml \
        Components/SessionButton.qml \
        Components/UserList.qml \
        --replace-fail 'import QtGraphicalEffects 1.0' 'import Qt5Compat.GraphicalEffects'

      echo "QtVersion=6" >> metadata.desktop
    '';

    installPhase = ''
      mkdir -p $out/share/sddm/themes/sugar-candy
      cp -r . $out/share/sddm/themes/sugar-candy
    '';
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    theme = "sugar-candy";
    extraPackages = with pkgs.kdePackages; [
      qt5compat
      qtsvg
    ];
  };

  environment.systemPackages = [ sugarCandy ];

  win.displayManager = "sddm";
}
