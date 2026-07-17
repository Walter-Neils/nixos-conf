{ config, pkgs, ... }:
let
  target = "Kanagawa-B-LB";
in
{
  environment.systemPackages = with pkgs; [
    kanagawa-gtk-theme
    kanagawa-icon-theme # Optional, but completes the look!
    gsettings-desktop-schemas
  ];

  environment.sessionVariables = {
    GTK_THEME = target; # or Kanagawa-BL-MB or whatever
    GTK_THEME_VARIANT = "dark";
  };

  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${target}
      gtk-icon-theme-name=Kanagawa
      gtk-application-prefer-dark-theme=1
    '';
    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name=${target}
      gtk-icon-theme-name=Kanagawa
      gtk-application-prefer-dark-theme=1
    '';
  };
}
