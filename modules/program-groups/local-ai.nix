{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../programs/ollama.nix
    # ../programs/llama.cpp.nix
  ];
}
