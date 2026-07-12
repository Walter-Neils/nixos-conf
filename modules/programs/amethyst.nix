{ config, pkgs, ... }:
{
  config = {
    assertions = [
      {
        assertion = config.services.flatpak.enable;
	message = "Amethyst Mod Manager requires flatpak";
      }
    ];

  services.flatpak.packages = [
    (let
      version = "2.0.2";
      appId = "io.github.Amethyst.ModManager";
      sha256 = "sha256-fpbIpuD6qwVDYJATNjpxLeVxZEBKS6MfK1UV3eS7eAQ=";
    in {
      inherit appId sha256;
      bundle = "${pkgs.fetchurl {
        url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v${version}/AmethystModManager.flatpak";
        inherit sha256;
      }}";
    })
  ];
services.flatpak.overrides = {
  "io.github.Amethyst.ModManager" = {
    Context = {
      # Give it access to talk to the desktop portals
      talk-name = [
        "org.freedesktop.portal.Desktop"
        "org.freedesktop.portal.OpenURI"
      ];
    };
  };
};
  };

}
