{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time${
        lib.optionalString (config.win.autologin.command != "") " --cmd ${config.win.autologin.command}"
      }";
      user = "greeter";
    };
  };

  win.displayManager = "greetd";
}
