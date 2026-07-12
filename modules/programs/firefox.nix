{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.win.limits.memory.browser;

  # Build the systemd flags only if the options are not null
  memoryHighFlag = lib.optionalString (cfg.memoryHigh != null) "-p MemoryHigh=${cfg.memoryHigh}";
  memoryMaxFlag = lib.optionalString (cfg.memoryMax != null) "-p MemoryMax=${cfg.memoryMax}";
in
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
          ${memoryHighFlag} \
          ${memoryMaxFlag} \
          ${pkgs.firefox}/bin/firefox "$@"
        EOF

                chmod +x $out/bin/firefox
      '';
    })
  ];
}
