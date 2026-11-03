{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.win.gameShare;

  # Lutris state that is shared between hosts. All of it is small: the SQLite
  # library (pga.db), one YAML file per game, and the artwork caches. Game
  # installs and Wine prefixes already live on the shared volume and are
  # referenced there by absolute path, which is why the mount point has to be
  # identical (/mnt/bulkgames) on every host.
  #
  # Deliberately NOT shared:
  #   lutris.conf  - window geometry plus per-host service toggles
  #   runners/     - several GB of Wine/Proton builds, installed per host
  #   runtime/     - same, per host
  sharedEntries = [
    "pga.db"
    "games"
    "banners"
    "coverart"
  ];

  # sharedEntries minus pga.db, which is a file rather than a directory.
  sharedDirs = [
    "games"
    "banners"
    "coverart"
  ];

  lutrisDataDir = "/home/${cfg.user}/.local/share/lutris";

  exports = ''
    ${cfg.exportPath} ${
      lib.concatStringsSep " " (
        map (client: "${client}(rw,sync,no_subtree_check)") cfg.server.allowedClients
      )
    }
  '';
in
{
  options.win.gameShare = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "walterineils";
      description = "User that owns the shared Lutris state. Its UID/GID must be identical on every host.";
    };

    server = {
      enable = lib.mkEnableOption "exporting the games volume over NFS";

      allowedClients = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "100.69.76.115" ];
        description = "Tailscale addresses allowed to mount the export.";
      };
    };

    client = {
      enable = lib.mkEnableOption "automounting the games volume over NFS";

      host = lib.mkOption {
        type = lib.types.str;
        default = "100.122.51.40";
        description = "Tailscale address of the host exporting the games volume.";
      };
    };

    exportPath = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/bulkgames";
      description = "Mount point of the shared volume. Must be identical on server and clients.";
    };

    sharedLutrisPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.win.gameShare.exportPath}/lutris-shared";
      defaultText = lib.literalExpression ''"''${config.win.gameShare.exportPath}/lutris-shared"'';
      description = "Directory on the shared volume holding the shared Lutris state.";
    };

    idmapDomain = lib.mkOption {
      type = lib.types.str;
      default = "internal";
      description = ''
        NFSv4 idmapping domain. Hosts that translate names differently (each
        derives its own from the hostname when `networking.domain` is unset)
        would resolve remote files to nobody. Numeric IDs already match, so a
        shared domain is only a safety net.
      '';
    };
  };

  config = lib.mkMerge [
    # Applied to both roles: link the shared entries into the local Lutris data
    # directory. Symlinks rather than a mount inside $HOME, because the entries
    # are tiny and a dangling symlink is harmless when a client cannot reach the
    # server (laptop away from the desktop). `L+` replaces whatever is currently
    # at the path, so the first activation converts the previous local
    # directories in place.
    {
      systemd.tmpfiles.rules = [
        "d ${lutrisDataDir} 0755 ${cfg.user} users -"
      ]
      ++ map (
        entry: "L+ ${lutrisDataDir}/${entry} - - - - ${cfg.sharedLutrisPath}/${entry}"
      ) sharedEntries;

      # Both hosts have to translate NFSv4 owners identically. UID/GID already
      # match (1000/100), so this only matters if idmapping ever kicks in.
      services.nfs.idmapd.settings.General.Domain = cfg.idmapDomain;
    }

    (lib.mkIf cfg.server.enable {
      services.nfs.server = {
        enable = true;
        inherit exports;
      };

      # The export table is built when the service starts, so the volume has to
      # be mounted underneath the export path first. Otherwise NFS would hand
      # out an empty directory and every game would look uninstalled.
      systemd.services.nfs-server.unitConfig.RequiresMountsFor = [ cfg.exportPath ];

      # NFSv4.2 carries locking and idmapping inside the protocol, so TCP 2049
      # is the only port that has to be reachable. Tailscale does not trust
      # tailscale0 by itself (modules/programs/tailscale.nix only starts the
      # daemon), hence the explicit per-interface rule: the export is reachable
      # from the tailnet and from nowhere else, LAN included.
      networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 2049 ];

      # Only the server creates the shared directories. Doing this from the
      # client would drag the NFS automount into every boot.
      systemd.tmpfiles.rules = [
        "d ${cfg.sharedLutrisPath} 0755 ${cfg.user} users -"
      ]
      ++ map (dir: "d ${cfg.sharedLutrisPath}/${dir} 0755 ${cfg.user} users -") sharedDirs;
    })

    (lib.mkIf cfg.client.enable {
      fileSystems.${cfg.exportPath} = {
        device = "${cfg.client.host}:${cfg.exportPath}";
        fsType = "nfs4";
        options = [
          "nfsvers=4.2"
          # Parallel TCP streams: WireGuard throttles a single flow and wifi
          # adds RTT, both of which a single NFS connection feels.
          "nconnect=4"
          # `hard` so a server that disappears mid-game cannot silently corrupt
          # data. Escape hatch if it ever wedges: `umount -f -l /mnt/bulkgames`.
          "hard"
          "timeo=150"
          "retrans=2"
          # uid/gid already match on every host, no POSIX ACLs needed.
          "noacl"
          # Mounted on first access, dropped when idle: the laptop boots and
          # works normally with the desktop off or out of reach, and a failed
          # mount costs a 20s stall instead of a hang.
          "noauto"
          "nofail"
          "_netdev"
          "x-systemd.automount"
          "x-systemd.idle-timeout=15min"
          "x-systemd.mount-timeout=20s"
        ];
      };
    })
  ];
}
