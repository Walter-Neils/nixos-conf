{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.services.custom-github-runner;

  # Build the official prebuilt runner tarball, patching the ELF binaries so
  # they run on NixOS.
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

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.patchelf
    ];

    # The generic strip hook chokes on the bundled PE/.NET assemblies and
    # corrupts them, so keep everything unstripped.
    dontStrip = true;

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

      # Drop Alpine/musl Node runtimes: they cannot run on a glibc runner and
      # only trip autoPatchelf's dependency resolution. Upstream nixpkgs'
      # github-runner likewise does not ship them.
      rm -rf $out/lib/actions-runner/externals/*_alpine

      # .NET's LTTng trace provider still links the obsolete soname; repoint it
      # at the ABI-compatible liblttng-ust.so.1 (same approach as the nixpkgs
      # powershell package).
      patchelf --replace-needed liblttng-ust.so.0 liblttng-ust.so.1 \
        $out/lib/actions-runner/bin/libcoreclrtraceptprovider.so

      # config.sh sanity-checks the .NET dependencies at registration time.
      # On NixOS neither `ldd` nor `ldconfig` is on the default PATH and there
      # is no ld.so.cache, so point the checks at glibc's tools and make sure
      # the ICU probe sees libicu by exporting it into LD_LIBRARY_PATH. Put
      # `nix` on PATH too so the .path/.env snapshot captured here includes it.
      substituteInPlace $out/lib/actions-runner/config.sh \
        --replace 'command -v ldd' 'command -v ${pkgs.glibc.bin}/bin/ldd' \
        --replace 'ldd ./bin/' '${pkgs.glibc.bin}/bin/ldd ./bin/' \
        --replace '/sbin/ldconfig' '${pkgs.glibc.bin}/bin/ldconfig' \
        --replace '$LDCONFIG_COMMAND -NXv ''${libpath//:/ }' 'echo libicu'
      sed -i '1a export PATH="${config.nix.package}/bin:$PATH"' \
        $out/lib/actions-runner/config.sh
      sed -i '2a export LD_LIBRARY_PATH="${pkgs.icu.outPath}/lib:${pkgs.openssl.out}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"' \
        $out/lib/actions-runner/config.sh

      runHook postInstall
    '';
  };

  seedScript = pkgs.writeShellScript "custom-github-runner-seed" ''
    set -eu

    mkdir -p '${cfg.workDir}'

    # Overlay the packaged runner into the writable state directory. The runner
    # resolves its root from its own location, so it must live outside the
    # read-only store. Files already in the work dir (.runner, .credentials,
    # _work/, _diag/) are preserved.
    cp -a '${runnerPkg}/lib/actions-runner/.' '${cfg.workDir}/'

    chmod -R u+rwX '${cfg.workDir}'
    chown -R '${cfg.user}:${cfg.group}' '${cfg.workDir}'
  '';
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
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.workDir;
      createHome = true;
    };

    users.groups.${cfg.group} = { };

    # Container jobs (`jobs.<id>.container`) cannot inherit the runner's
    # ambient PATH. To use nix inside a container, mount the host store and
    # daemon socket and use an image carrying the nix CLI, e.g.:
    #
    #   container:
    #     image: nixos/nix:latest
    #     options: >-
    #       -v /nix:/nix:ro
    #       -v /nix/var/nix/daemon-socket:/nix/var/nix/daemon-socket
    #
    # The runner user already has docker access, so no host-side change is
    # needed beyond this.

    # Pushes a fresh copy of the packaged runner into the writable work dir.
    # Runs (as root) once at boot; can also be started manually to seed the
    # work dir ahead of running ./config.sh.
    systemd.services.custom-github-runner-seed = {
      description = "Seed GitHub Actions Runner files into the state directory";
      wantedBy = [ "multi-user.target" ];
      before = [ "custom-github-runner.service" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = seedScript;
        RemainAfterExit = true;
      };
    };

    systemd.services.custom-github-runner = {
      description = "GitHub Actions Runner";
      after = [
        "custom-github-runner-seed.service"
        "network-online.target"
      ];
      wants = [
        "custom-github-runner-seed.service"
        "network-online.target"
      ];
      wantedBy = [ "multi-user.target" ];

      # Standard toolchain available to workflows. `nix` is on the ambient
      # PATH so workflow steps can drive the host's nix daemon.
      path =
        (with pkgs; [
          bash
          coreutils
          git
          curl
          gnutar
          gzip
        ])
        ++ [
          config.nix.package
        ]
        ++ cfg.extraPackages;

      environment = {
        HOME = cfg.workDir;
        # .NET resolves libicu and libssl by name (dlopen) at runtime rather
        # than via NEEDED/RUNPATH, so point the loader at them explicitly.
        LD_LIBRARY_PATH = "${pkgs.icu.outPath}/lib:${pkgs.openssl.out}/lib";
      };

      # Only start if the runner has already been configured via ./config.sh
      unitConfig = {
        ConditionPathExists = "${cfg.workDir}/.runner";
      };

      serviceConfig = {
        ExecStart = "${cfg.workDir}/run.sh";
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
