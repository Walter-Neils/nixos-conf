{
  lib,
  config,
  ...
}:
{
  # Brute-force / scanner protection. Import this module on hosts that should
  # run fail2ban (it's opt-in, not in common.nix).
  #
  # NixOS automatically provides an `sshd` jail while OpenSSH is enabled and
  # sets sshd LogLevel=VERBOSE so failed attempts are observable. Tune the
  # top-level maxretry/bantime/ignoreIP as desired.
  services.fail2ban = {
    enable = true;
    # Number of failures before a ban.
    maxretry = 5;
    # Duration of a ban.
    bantime = "1h";
    # Never ban the tailnet (CGNAT 100.64.0.0/10).
    ignoreIP = [ "100.64.0.0/10" ];
  };
}