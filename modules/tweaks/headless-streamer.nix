{ pkgs, inputs, ... }:
{

  environment.systemPackages = with pkgs; [
    sway
  ];
  systemd.user.services.sunshine-headless = {
    description = "Headless Streaming Session for Sunshine";
    wantedBy = [ "default.target" ];
    after = [
      "pipewire.service"
      "wireplumber.service"
    ];

    environment = {
      # Isolate from Hyprland's wayland-0
      WAYLAND_DISPLAY = "wayland-headless-1";
      XDG_CURRENT_DESKTOP = "sway";
      WLR_BACKENDS = "headless";
      WLR_LIBINPUT_NO_DEVICES = "1";
      PULSE_SINK = "sink-sunshine-stream";
    };

    serviceConfig = {
      Restart = "on-failure";
      RestartSec = 2;
      ExecStart = pkgs.writeShellScript "start-sunshine-headless" ''
        # 1. Ensure a dedicated PipeWire null sink exists for stream audio
        ${pkgs.pipewire}/bin/pw-cli create-node adapter \
          '{ factory.name=support.null-audio-sink node.name="sink-sunshine-stream" media.class="Audio/Sink" object.linger=true }' || true

        # 2. Launch headless Sway compositor
        ${pkgs.sway}/bin/sway --config ${pkgs.writeText "sway-headless.conf" ''
          output HEADLESS-1 resolution 2560x1440@120Hz
          exec ${pkgs.sunshine}/bin/sunshine
        ''}
      '';
    };
  };
}
