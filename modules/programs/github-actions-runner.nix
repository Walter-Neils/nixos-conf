{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.services.custom-github-runner;

  # Build package directly using autoPatchelfHook for ELF binary dependencies
  runnerPkg = pkgs.stdenv.mkDerivation rec {
    pname = "actions-runner";
    version = "2.337.0";

    src = pkgs.fetchurl {
      url = "https://github.com/actions/runner/releases/download/v${version}/actions-runner-linux-x64-${version}.tar.gz";
      # Update with the SRI hash from:
      # nix store prefetch-file https://github.com/actions/runner/releases/download/v2.337.0/actions-runner-linux-x64-2.337.0.tar.gz
      hash = "sha256-cJIIEaT4rUMogYaCvKXGRpwclC+rUkSIaAcdAGOBZhM=";
    };

    sourceRoot = ".";

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];

    buildInputs = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      icu
      krb5
      lttng-ust
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/lib/actions-runner
      cp -r . $out/lib/actions-runner/

      # Symlink runner scripts into bin
      ln -s $out/lib/actions-runner/run.sh $out/bin/actions-runner
      ln -s $out/lib/actions-runner/config.sh $out/bin/actions-runner-config
      runHook postInstall
    '';
  };
in
{
  options.services.custom-github-runner = {
    enable = lib.mkEnableOption "Self-hosted GitHub Actions Runner";

    workDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/actions-runner";
      description = "State directory where the runner configuration and job workspaces reside.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "github-runner";
      description = "User account under which the runner service executes.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "github-runner";
      description = "Primary group for the runner service.";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra packages to place on the runner systemd service PATH.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Provide runner binaries in the system path for manual registration
    environment.systemPackages = [ runnerPkg ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.workDir;
      createHome = true;
    };

    users.groups.${cfg.group} = { };

    systemd.services.custom-github-runner = {
      description = "GitHub Actions Runner";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      # Standard toolchain available to workflows
      path = with pkgs; [
        bash
        coreutils
        git
        curl
        gnutar
        gzip
      ] ++ cfg.extraPackages;

      # Only start if the runner has already been configured via ./config.sh
      unitConfig = {
        ConditionPathExists = "${cfg.workDir}/.runner";
      };

      serviceConfig = {
        ExecStart = "${runnerPkg}/bin/actions-runner";
        WorkingDirectory = cfg.workDir;
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = "10s";
        KillMode = "process";
        KillSignal = "SIGINT";
        TimeoutStopSec = "5min";
      };
    };
  };
}
