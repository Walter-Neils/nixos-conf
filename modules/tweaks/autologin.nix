{
  pkgs,
  inputs,
  config,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = config.win.autologin.command;
        user = config.win.autologin.user;
      };
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${config.win.autologin.command}";
        user = "greeter";
      };
    };
  };
  win.displayManager = "greetd";
}
