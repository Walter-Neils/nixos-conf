{ pkgs, inputs, ... }:
{
  options = {
    services.autologin = {
        autologinUser = lib.mkOption {
            type = lib.types.str;
            description = "The user that should automatically be logged in.";
        };
        autologinCommand = lib.mkOption {
            type = lib.types.str;
            description = "A command which starts a session";
        };
    };
  };

  config = {
   services.greetd = {
     enable = true;
     settings = {
       initial_session = {
         command = config.services.autologin.autologinCommand;
         user = config.services.autologin.autologinUser;
       };
       default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${config.services.autologin.autologinCommand}";
        user = "greeter";
       };
     }
   }
  };
}
