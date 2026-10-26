{
  pkgs,
  config,
  inputs,
  lib,
  ...
}:
{
  options.win.autologin = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "The user that should automatically be logged in.";
    };
    command = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "A command which starts a session, used by command-based display managers such as greetd.";
    };
  };
}
