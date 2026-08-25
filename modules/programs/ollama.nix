{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama-vulkan;
  };

  systemd.services.ollama.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "ollama";
    Group = "ollama";
  };

  # Ensure the system user exists
  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    home = "/var/lib/ollama";
    createHome = false;
  };
  users.groups.ollama = { };

  services.open-webui = {
    enable = true;
    package = pkgs-unstable.open-webui; # Use unstable for the latest features
    port = 8080;
    host = "127.0.0.1"; # Change to "0.0.0.0" to access from other devices on your LAN
    environment = {
      # Point Open WebUI to your local Ollama instance
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      # Optional: Disable signup/login if this is a single-user local machine
      WEBUI_AUTH = "False";
    };
  };
}
