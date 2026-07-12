{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  services.flatpak.enable = true;

  services.flatpak.remotes = pkgs.lib.mkOptionDefault [
    {
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }
  ];
}
