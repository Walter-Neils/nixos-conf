{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./cli.nix
    ../programs/neovim.nix
    ../programs/neovide.nix
    ../programs/git.nix
    ../programs/jujutsu.nix
    ../programs/tealdeer.nix
  ];
}
