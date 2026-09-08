{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.win.limits.memory.browser;

  hasLimits = cfg.memoryHigh != null || cfg.memoryMax != null;

  memoryHighFlag = lib.optionalString (cfg.memoryHigh != null) "-p MemoryHigh=${cfg.memoryHigh}";
  memoryMaxFlag = lib.optionalString (cfg.memoryMax != null) "-p MemoryMax=${cfg.memoryMax}";

  firefoxWrapped = pkgs.symlinkJoin {
    name = "firefox-limited";
    paths = [ pkgs.firefox ];
    postBuild = ''
      rm $out/bin/firefox

      cat << 'EOF' > $out/bin/firefox
      #!/bin/sh
      exec ${pkgs.systemd}/bin/systemd-run \
        --user \
        --scope \
        ${memoryHighFlag} \
        ${memoryMaxFlag} \
        ${pkgs.firefox}/bin/firefox "$@"
      EOF

      chmod +x $out/bin/firefox
    '';
  };
in
{
  environment.systemPackages = [
    (if hasLimits then firefoxWrapped else pkgs.firefox)
  ];
}
