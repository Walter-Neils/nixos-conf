{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.vanilla = {
      enable = true;
      jvmOpts = "-Xmx4G -Xms2G";

      # Specify the custom minecraft server package
      package = pkgs.minecraftServers.vanilla;
      serverProperties = {
        white-list = false;
        enforce-whitelist = false;
      };
    };
  };
}
