{ pkgs, inputs, config, ... }:
{
  systemd.services.win-update = {
    description = "Auto-update the NixOS install";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    path = with pkgs; [ 
      nixos-rebuild 
      nix           # Needed by nixos-rebuild
      git           # Needed to fetch github: flakes
      openssh       # Needed if your github fetch uses SSH keys
    ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "my-boot-script" ''
      #!/usr/bin/env bash
      sleep 30
      HOSTNAME=$(cat /etc/hostname)
      nixos-rebuild boot --refresh --flake github:Walter-Neils/nixos-conf#$HOSTNAME
    ''}";
    };
  };
}
