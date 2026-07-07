{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    slurp
    grim
    hyprpolkitagent
  ];
  hardware.graphics = {
    package = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.mesa;
    package32 =
      inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pkgsi686Linux.mesa;
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

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
