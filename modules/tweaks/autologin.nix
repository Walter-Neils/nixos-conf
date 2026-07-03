{ pkgs, inputs, ... }:
    let
        start_hyprland = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/bin/start-hyprland";
{

  # 2. Configure greetd for autologin
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${start_hyprland}";
        user = "walterineils";
      };
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${start_hyprland}";
        user = "greeter";
      };
    };
  };

}
