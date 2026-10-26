{
  config,
  lib,
  ...
}:
let
  cfg = config.win.autologin;
  dm = config.win.displayManager;
in
{
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = lib.elem dm [
            "greetd"
            "sddm"
          ];
          message = "win.autologin supports greetd and sddm (selected: ${dm}).";
        }
        {
          assertion = dm != "greetd" || cfg.command != "";
          message = "greetd autologin requires win.autologin.command.";
        }
        {
          assertion = dm != "sddm" || config.services.displayManager.defaultSession != null;
          message = "SDDM autologin requires services.displayManager.defaultSession.";
        }
      ];
    }

    (lib.mkIf (dm == "greetd") {
      services.greetd.settings.initial_session = {
        inherit (cfg) command user;
      };
    })

    (lib.mkIf (dm == "sddm") {
      services.displayManager.autoLogin = {
        enable = true;
        inherit (cfg) user;
      };
    })
  ];
}
