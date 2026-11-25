# CachyOS kernel (https://github.com/xddxdd/nix-cachyos-kernel).
#
# Opt in per host:
#   win.cachyosKernel.enable = true;
#   win.cachyosKernel.variant = "linuxPackages-cachyos-bore-lto-x86_64-v3";
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.win.cachyosKernel;
in
{
  options.win.cachyosKernel = {
    enable = lib.mkEnableOption "the CachyOS kernel instead of the kernel in modules/common.nix";

    variant = lib.mkOption {
      type = lib.types.str;
      default = "linuxPackages-cachyos-bore-lto";
      example = "linuxPackages-cachyos-bore-lto-x86_64-v3";
      description = ''
        Which entry of `pkgs.cachyosKernels` to boot. `-lto` variants are
        Clang+ThinLTO; `x86_64-v3` requires a CPU with AVX2, `zen4` needs
        AVX-512. See `nix flake show github:xddxdd/nix-cachyos-kernel/release`
        for the full list.
      '';
    };
  };

  config = lib.mkMerge [
    {
      # Applied unconditionally on purpose: guarding this on `cfg.enable` makes
      # `pkgs` depend on `config`, which depends on `pkgs.cachyosKernels` again
      # (infinite recursion). `cachyosKernels` is a lazy attribute, so hosts
      # that never reference it evaluate nothing extra.
      nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
    }

    (lib.mkIf cfg.enable {
      boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.${cfg.variant};

      # Upstream Hydra binary cache for these kernels. Takes effect on the
      # rebuild *after* this is applied; for the first switch, pass it manually:
      #   nixos-rebuild switch --flake .#<host> \
      #     --option extra-substituters https://cache.lantian.pub/lantian \
      #     --option extra-trusted-public-keys 'lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ='
      nix.settings.substituters = [ "https://cache.lantian.pub/lantian" ];
      nix.settings.trusted-public-keys = [
        "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="
      ];
    })
  ];
}
