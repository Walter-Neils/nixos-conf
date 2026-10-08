{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  services.kmscon = {
    enable = true;
    useXkbConfig = true;
    hwRender = true; # Keeps hardware acceleration enabled for your release

    # Use extraConfig as a raw configuration string for your specific NixOS version
    extraConfig = ''
      font-name=JetBrainsMono Nerd Font
      font-size=14
    '';
  };
}
