{ pkgs, ... }: {

  # 2. Configure greetd for autologin
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/bin/start-hyprland";
        user = "walterineils";
      };
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/bin/start-hyprland";
        user = "greeter";
      };
    };
  };

}
