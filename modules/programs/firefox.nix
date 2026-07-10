{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    firefox
    (writeShellScriptBin "firefox" ''
      exec ${systemd}/bin/systemd-run \
        --user \
        --scope \
        --unit="firefox-limited" \
        -p MemoryHigh=3.5G \
        -p MemoryMax=4G \
        ${firefox}/bin/firefox "$@"
    '')
  ];
}
