{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/fish.nix
    ../programs/tmux.nix
    ../programs/kitty.nix
  ];

  environment.systemPackages = with pkgs; [
    wget
    eza
    fastfetch
    starship
    direnv
    duf
    bat
    ripgrep
    btop
  ];
}
