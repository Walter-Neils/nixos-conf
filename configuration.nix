# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld = {
    enable = true;
    libraries =
      with pkgs;
      [ fuse ]
      ++ (pkgs.appimageTools.defaultFhsEnvArgs.targetPkgs pkgs)
      ++ (pkgs.appimageTools.defaultFhsEnvArgs.multiPkgs pkgs);
  };

  programs.appimage.enable = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  services.logind.settings.Login.HandleLidSwitch = "suspend";
  services.logind.settings.Login.HandleLidSwitchDocked = "suspend";

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";   # wherever your ESP is mounted
    };

    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
  };

  services.chrony.enable = true;

  services.envfs.enable = true;

  services.resolved.enable = true;

  boot.tmp.cleanOnBoot = true;

  networking.hostName = "NCC-1701-C";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.walterineils = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "audio"
      "networkmanager"
      "sudo"
      "docker"
      "podman"
      "dialout"
    ];
    shell = pkgs.unstable.fish;
  };

  programs.fish.enable = true;

  programs.git.enable = true;

  hardware.graphics = {
    enable = true;
    package = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.mesa;
    enable32Bit = true;
    package32 =
      inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.pkgsi686Linux.mesa;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
    extraPackages32 = with pkgs; [
      intel-vaapi-driver
    ];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  programs.firefox.enable = true;
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    unstable.neovim
    unstable.kitty
    tmux
    wget
    inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };
  networking.firewall.enable = false;

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    PATH = [
      "$HOME/.npm-global/bin"
      "$XDG_DATA_HOME/pnpm/bin"
      "$HOME/.deno/bin"
      "$HOME/go/bin"
      "$HOME/.cargo/bin"
    ];

    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    LIBVA_DRIVER_NAME = "iHD";
  };

  environment.localBinInPath = true;

  services.openssh.enable = true;
  services.tailscale.enable = true;

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
