{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../program-groups/terminal.nix
    ../programs/neovim.nix
    ../programs/git.nix
    ../programs/jujutsu.nix
    ../programs/tealdeer.nix
    ../programs/kitty.nix
  ];
}
