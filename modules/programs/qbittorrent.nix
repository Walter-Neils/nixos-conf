{ config, pkgs, ... }:
{
  assertions = [
    {
      assertion = config.networking.firewall.enable == true;

      message = ''
        Refusing to build system: the qBitTorrent VPN kill-switch rules rely entirely on the firewall.
        Building without firewall support may lead to VPN torrent leaks, which can land you in legal trouble.
      '';
    }
  ];

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    user = "qbittorrent";
  };

  networking.firewall = {
    enable = true;

    # Loopback 'lo' gives us the local web interface at :8080
    # tun+, wg+, proton+ give us typical VPN interfaces
    extraCommands =
      let
        targetUser = config.services.qbittorrent.user;
      in
      ''
        iptables -A OUTPUT -m owner --uid-owner ${targetUser} -o lo -j ACCEPT
        iptables -A OUTPUT -m owner --uid-owner ${targetUser} -o tun+ -j ACCEPT
        iptables -A OUTPUT -m owner --uid-owner ${targetUser} -o wg+ -j ACCEPT
        iptables -A OUTPUT -m owner --uid-owner ${targetUser} -o proton+ -j ACCEPT
        iptables -A OUTPUT -m owner --uid-owner ${targetUser} -j REJECT --reject-with icmp-port-unreachable
      '';

    extraStopCommands =
      let
        targetUser = config.services.qbittorrent.user;
      in
      ''
        iptables -D OUTPUT -m owner --uid-owner ${targetUser} -o lo -j ACCEPT 2>/dev/null || true
        iptables -D OUTPUT -m owner --uid-owner ${targetUser} -o tun+ -j ACCEPT 2>/dev/null || true
        iptables -D OUTPUT -m owner --uid-owner ${targetUser} -o wg+ -j ACCEPT 2>/dev/null || true
        iptables -D OUTPUT -m owner --uid-owner ${targetUser} -o proton+ -j ACCEPT 2>/dev/null || true
        iptables -D OUTPUT -m owner --uid-owner ${targetUser} -j REJECT 2>/dev/null || true
      '';
  };
}
