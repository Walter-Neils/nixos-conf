{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe makeBinPath mkForce;

  sunshineBin =
    if config.services.sunshine.capSysAdmin then
      "${config.security.wrapperDir}/sunshine"
    else
      getExe config.services.sunshine.package;

  # Sunshine's wlgrab backend connects to a Wayland compositor, but this unit
  # starts outside the graphical session and inherits no WAYLAND_DISPLAY, so
  # capture init fails ("Unable to initialize capture method" +
  # "Is a display connected and turned on?"). Resolve the interactive
  # compositor's socket at startup instead of hardcoding wayland-N: the number
  # depends on start order (a headless sway took wayland-1 and pushed Hyprland
  # to wayland-2).
  sunshineStart = pkgs.writeShellScript "sunshine-wayland-start" ''
    export PATH=${makeBinPath (with pkgs; [ coreutils gnugrep systemd wayland-utils ])}
    export XDG_CURRENT_DESKTOP=Hyprland
    runtime_dir="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

    has_socket() { [ -n "''${WAYLAND_DISPLAY:-}" ] && [ -S "$runtime_dir/$WAYLAND_DISPLAY" ]; }

    # 1. what the session exported into the user manager
    if ! has_socket; then
      WAYLAND_DISPLAY=
      while IFS='=' read -r key value; do
        [ "$key" = WAYLAND_DISPLAY ] && WAYLAND_DISPLAY="$value"
      done < <(systemctl --user show-environment 2>/dev/null)
    fi

    # 2. otherwise, the compositor speaking Hyprland's private protocols
    if ! has_socket; then
      for socket in "$runtime_dir"/wayland-*; do
        [ -S "$socket" ] || continue
        candidate="''${socket##*/}"
        if WAYLAND_DISPLAY="$candidate" wayland-info 2>/dev/null | grep -q hyprland_; then
          WAYLAND_DISPLAY="$candidate"
          break
        fi
      done
    fi

    if has_socket; then
      export WAYLAND_DISPLAY
      echo "sunshine: streaming Wayland session on $WAYLAND_DISPLAY" >&2
    else
      echo "sunshine: no Wayland socket found, capture will fail" >&2
    fi

    exec ${sunshineBin} "$@"
  '';
in
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # Wayland support
    openFirewall = true;
  };

  # NOTE: this drops the extra sunshine.conf argument the NixOS module appends
  # when services.sunshine.settings/applications are set; config lives in
  # ~/.config/sunshine/sunshine.conf here.
  systemd.user.services.sunshine.serviceConfig.ExecStart = mkForce sunshineStart;
}
