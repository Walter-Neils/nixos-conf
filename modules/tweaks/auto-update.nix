{ pkgs, inputs, config, ... }:
{
  systemd.services.win-update = {
    description = "Auto-update the NixOS install";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "my-boot-script" ''
      #!/usr/bin/env bash
      HOSTNAME=$(cat /etc/hostname)
      nixos-rebuild switch --refresh --flake github:Walter-Neils/nixos-conf#$HOSTNAME
    ''}";
    };
  };
}
