{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  llamaPkg = pkgs.unstable.llama-cpp.override {
    vulkanSupport = true;
  };
in
{
  environment.systemPackages = [
    llamaPkg
  ];

  # Set up cache and data directories
  systemd.tmpfiles.rules = [
    "d /var/lib/llama-cpp 0750 llama-cpp llama-cpp -"
    "d /var/cache/llama-cpp 0750 llama-cpp llama-cpp -"
  ];

  # Dedicated system user with GPU group access
  users.users.llama-cpp = {
    isSystemUser = true;
    group = "llama-cpp";
    extraGroups = [
      "video"
      "render"
    ];
  };
  users.groups.llama-cpp = { };

  # llama.cpp systemd service
  systemd.services.llama-cpp = {
    description = "llama.cpp HTTP Inference Server";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      # Direct Hugging Face downloads to a dedicated cache folder
      HF_HOME = "/var/cache/llama-cpp/hf";
    };

    serviceConfig = {
      Type = "simple";
      User = "llama-cpp";
      Group = "llama-cpp";
      WorkingDirectory = "/var/lib/llama-cpp";
      ExecStart = ''
                ${llamaPkg}/bin/llama-server \
                  -hf unsloth/Qwen3.8-27B-GGUF:UD-Q4_K_XL \
                  -ngl 99 \
                  -c 32768 \
        	  --tools all \
                  --host 127.0.0.1 \
                  --port 8080
      '';
      Restart = "on-failure";
      RestartSec = 5;

      # Sandboxing & security hardening
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      ReadWritePaths = [
        "/var/lib/llama-cpp"
        "/var/cache/llama-cpp"
      ];
      DevicePolicy = "closed";
      DeviceAllow = [
        "/dev/dri/renderD* rw"
        "/dev/dri/card* rw"
      ];
    };
  };
}
