{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.samba = {
    enable = true;
    openFirewall = true;

    # nixpkgs' Samba is built with --disable-cups by default. Without this,
    # `printing = CUPS`, `load printers = yes` and the [printers] share are
    # silently non-functional.
    package = pkgs.samba.override { enablePrinting = true; };

    # There is no AD/domain here; nmbd provides WINS and the old NAS used
    # smbd + nmbd only.
    winbindd.enable = false;

    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "Samba Server";
        "netbios name" = "NAS";
        security = "user";
        "map to guest" = "Bad User";
        "server role" = "standalone server";

        printing = "CUPS";
        "load printers" = "yes";

        # Match the existing Arch smb.conf exactly.
        "server min protocol" = "SMB3";
        "vfs objects" = "io_uring acl_xattr";
        "server multi channel support" = "yes";
        "aio read size" = "1";
        "aio write size" = "1";
        "use sendfile" = "yes";
        "strict allocate" = "yes";
        "allocation roundup size" = "0";

        locking = "yes";
        "wins support" = "yes";

        oplocks = "yes";
        "level2 oplocks" = "yes";
        "kernel oplocks" = "no";
        "smb2 leases" = "yes";
        "acl allow execute always" = "true";
        "acl map full control" = "yes";
        deadtime = "60";
        "min receivefile size" = "16384";
        "strict sync" = "no";
        "sync always" = "no";

        "socket options" = "TCP_NODELAY IPTOS_THROUGHPUT SO_RCVBUF=131072 SO_SNDBUF=131072";
        "getwd cache" = "yes";
      };

      printers = {
        comment = "All Printers";
        path = "/var/spool/samba";
        browseable = "yes";
        printable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };

      "print$" = {
        comment = "Printer Drivers";
        path = "/var/lib/samba/printers";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
      };

      "VSI Live Data" = {
        path = "/mnt/ventry-live_data";
        writable = "yes";
        browseable = "yes";
        "guest ok" = "no";
        "read only" = "no";
        "valid users" = [ "@ventry" ];
        "force group" = "ventry";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/spool/samba 1777 root root -"
    "d /var/lib/samba/printers 0755 root root -"
  ];

  # Do not expose an empty root-filesystem directory if the data LV failed to
  # mount, and make sure CUPS is up before smbd enumerates printers.
  systemd.services.samba-smbd = {
    wants = [
      "cups.service"
      "ensure-vsi-printers.service"
    ];
    after = [
      "cups.service"
      "ensure-vsi-printers.service"
    ];
    unitConfig.RequiresMountsFor = lib.mkForce "/var/lib/samba /mnt/ventry-live_data";
  };
}
