{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./caelestia.nix
    ./wl-clipboard.nix
  ];
  environment.systemPackages = with pkgs; [
    slurp
    grim
    hyprpolkitagent
  ];
  # NOTE: Do NOT override hardware.graphics.package with the Hyprland flake's
  # Mesa. That Mesa is built from Hyprland's own pinned nixpkgs (nixos-unstable),
  # which uses a newer glibc than this system's nixpkgs (nixos-26.05). Mixing the
  # two makes EGL/Vulkan fail to load in system apps (no WebGL in browsers,
  # neovide won't launch). Hyprland loads Mesa through libglvnd at runtime, so
  # the system Mesa works fine. Enable/32-bit are set in modules/common.nix.
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  services.displayManager.defaultSession = lib.mkDefault "hyprland";

  system.userActivationScripts = {
    updateHyprlandLuarc.text = ''
      LUARC_PATH="$XDG_CONFIG_HOME/hypr/.luarc.json"
      STUB_PATH="${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/share/hypr/stubs"
      [[ ! -s "$LUARC_PATH" ]] && printf '{}' > "$LUARC_PATH"
      cat <<< "$(${pkgs.jq}/bin/jq --arg new "$STUB_PATH" '
        .workspace.library |= (. // [] | if any(endswith("/share/hypr/stubs"))
            then map(if endswith("/share/hypr/stubs") then $new else . end)
            else [$new] + .
            end)
      ' "$LUARC_PATH")" > "$LUARC_PATH"
    '';
  };

  win.autologin.command = lib.mkDefault "${
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
  }/bin/start-hyprland";
}
