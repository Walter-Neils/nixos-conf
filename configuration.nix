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
    grub.device = "nodev";
    grub.enable = true;
    efi.canTouchEfiVariables = false;
    efi.efiSysMountPoint = "/boot";
  };

  services.chrony.enable = true;

  services.envfs.enable = true;

  services.resolved.enable = true;

  boot.tmp.cleanOnBoot = true;

  networking.hostName = "NCC-1701-D";

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

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    unstable.neovim
    tmux
    wget
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

  services.openssh.enable = true;
  services.tailscale.enable = true;

  # DO NOT CHANGE THIS. For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.11"; # Did you read the comment?
}
