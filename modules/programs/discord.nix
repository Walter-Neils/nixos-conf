{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: 
{
  config = {
    assertions = [
      {
        assertion = config.services.flatpak.enable;
	message = "Discord requires flatpak (Krisp support)";
      }
    ];

  services.flatpak.packages = [
    "com.discordapp.Discord"
  ];  

  services.flatpak.overrides = {
    "com.discordapp.Discord" = {
      Context = {
        # 1. Allows Discord to read system processes (Fixes "Activity Status" / game detection)
        filesystems = [ "xdg-run/pipewire-0" ]; 
        sockets = [ "x11" "wayland" "pulseaudio" ];
      };
    };
  };
  };
}
