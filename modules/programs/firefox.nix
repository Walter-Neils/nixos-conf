{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (pkgs.symlinkJoin {
      name = "firefox-limited";
      paths = [ pkgs.firefox ]; # Brings in desktop items, icons, and policies
      postBuild = ''
                rm $out/bin/firefox

                cat << 'EOF' > $out/bin/firefox
        #!/bin/sh
        exec ${pkgs.systemd}/bin/systemd-run \
          --user \
          --scope \
          --unit="firefox-limited" \
          -p MemoryHigh=3.5G \
          -p MemoryMax=4G \
          ${pkgs.firefox}/bin/firefox "$@"
        EOF

                chmod +x $out/bin/firefox
      '';
    })
  ];
}
