{ pkgs, inputs, ... }:
{
  options = {
    services.greetd.autologinUser = lib.mkOption {
      type = lib.types.str;
      description = "The user that should automatically be logged in.";
    };
    services.greetd.autoLoginCommand = lib.mkOption {
      type = lib.types.str;
      description = "A command which starts a session";
    };
  };

  config = {
   services.greetd = {
     enable = true;
     settings = {
       initial_session = {
         command = config.services.greetd.autoLoginCommand;
         user = config.services.greetd.autologinUser;
       };
       default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${config.services.greetd.autoLoginCommand}";
        user = "greeter";
       };
     }
   }
  };
}
