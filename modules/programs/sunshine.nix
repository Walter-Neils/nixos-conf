{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
    services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true; # Wayland support
        openFirewall = true;
    };
}
