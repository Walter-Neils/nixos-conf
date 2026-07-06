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
    ./programs/flatpak.nix
    ./programs/caelestia.nix
    ./programs/docker.nix
    ./programs/hyprland.nix
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

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      configurationLimit = 5;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.chrony.enable = true;

  services.envfs.enable = true;

  services.resolved.enable = true;

  boot.tmp.cleanOnBoot = true;

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
      "uinput"
    ];
    shell = pkgs.unstable.fish;
  };

  programs.fish.enable = true;

  programs.git.enable = true;

  programs.firefox.enable = true;

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    unstable.neovim
    unstable.kitty
    tmux
    wget
    eza
    fastfetch
    starship
    direnv
    duf
    bat
    power-profiles-daemon
    ripgrep
    moonlight-qt
    lutris
    wine
    steam
    r2modman
    gh
    zenity
    slurp
    grim
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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
