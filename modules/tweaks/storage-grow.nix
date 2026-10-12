{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Automatically grow `root_vg/root` when free space appears in the VG. This
  # is how hosts that use LVM absorb newly attached block volumes:
  #
  #   pvcreate /dev/sdb
  #   vgextend root_vg /dev/sdb
  #
  # and then either wait for the timer or run this unit explicitly:
  #
  #   systemctl start storage-grow
  #
  # To remove a volume again: pvmove /dev/sdb, vgreduce root_vg /dev/sdb,
  # then detach the block volume in the OCI console.
  systemd.services.storage-grow = {
    description = "Grow root_vg/root into free LVM space";
    after = [ "lvm2-pvscan.service" ];
    wants = [ "lvm2-pvscan.service" ];
    wantedBy = [ "multi-user.target" ];

    path = with pkgs; [
      lvm2
      btrfs-progs
      coreutils
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      set -eu

      # Refresh VG metadata so hot-added PVs are visible.
      pvscan --cache -q 2>/dev/null || true

      FREE=$(vgs --noheadings -o vg_free_count root_vg 2>/dev/null | tr -d ' ') || FREE=0
      if [ "''${FREE:-0}" -gt 0 ]; then
        lvextend -l +100%FREE /dev/root_vg/root
        btrfs filesystem resize max / || true
      fi
    '';
  };

  # Re-check periodically so a volume attached while the host is running is
  # picked up without a reboot.
  systemd.timers.storage-grow = {
    description = "Periodically grow root_vg/root into free LVM space";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
      RandomizedDelaySec = "30s";
    };
  };
}