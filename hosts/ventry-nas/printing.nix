{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.printing = {
    # Keep cupsd running: Samba loads printers from CUPS at startup.
    startWhenNeeded = false;
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    openFirewall = true;
    defaultShared = true;
    browsing = true;
    webInterface = true;

    # Provides gstopxl, referenced by the LaserJet PCL 6 PPDs.
    drivers = [ pkgs.cups-filters ];

    # Do not import printers discovered from the LAN; cupsd still advertises
    # the local queues over Avahi, matching the old Arch setup.
    browsed.enable = false;

    extraConf = ''
      ServerAlias *
      ErrorPolicy stop-printer
      BrowseLocalProtocols dnssd
    '';
  };

  # hardware.printers uses `lpadmin -m`, which CUPS 2.4 rejects for absolute
  # PPD paths ("cups-driverd failed to get PPD file"). Install the PPDs
  # explicitly with `-i`, and create the class/default in the same service.
  systemd.services.ensure-vsi-printers = {
    description = "Ensure VSI CUPS printers and class";
    wantedBy = [ "multi-user.target" ];
    wants = [ "cups.service" ];
    after = [ "cups.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      set -e
      LP=${pkgs.cups}/bin/lpadmin

      $LP -p HP_LaserJet_4050_Series -v socket://192.168.1.117 \
        -D "HP LaserJet 4050 Series" -L "VSI Shop" \
        -i ${./ppd/HP_LaserJet_4050_Series.ppd} \
        -E -o printer-is-shared=true

      $LP -p hp_LaserJet_4200 -v socket://192.168.1.185 \
        -D "hp LaserJet 4200" -L "VSI Shop" \
        -i ${./ppd/hp_LaserJet_4200.ppd} \
        -E -o printer-is-shared=true

      $LP -p UPSPrinter -v socket://192.168.1.185 \
        -D "UPS Printer" \
        -i ${./ppd/UPSPrinter.ppd} \
        -E -o printer-is-shared=true

      $LP -d hp_LaserJet_4200
      $LP -p hp_LaserJet_4200 -c VSIAllPrinters || true
      $LP -p VSIAllPrinters -E \
        -D "All VSI Printers" \
        -L "VSI Shop" \
        -o printer-error-policy=retry-current-job \
        -o printer-is-shared=true
    '';
  };
}
