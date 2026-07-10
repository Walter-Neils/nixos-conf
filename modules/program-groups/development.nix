{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/neovim.nix
    ../programs/git.nix
    ../programs/jujutsu.nix
    ../programs/tealdeer.nix
  ];
}
