{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    unstable.neovim
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };
}
