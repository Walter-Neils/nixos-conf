{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    neovim
  ];


  environment.sessionVariables = {
    EDITOR = "nvim";
  };
}
