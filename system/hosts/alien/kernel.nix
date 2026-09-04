# system/hosts/alien/kernel.nix
{
  lib,
  pkgs,
  inputs,
  users,
  ...
}:
{
  boot = {
    kernelModules = [ "ddcci_backlight" ];
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
  };

  environment.systemPackages = with pkgs; [
    ddcutil
    openrgb
  ];

  hardware.i2c.enable = true;

  nix.settings.system-features = [
    "nixos-test"
    "benchmark"
    "big-parallel"
    "kvm"
    "gccarch-x86-64-v3"
  ];

  nixpkgs = {
    # hostPlatform = {
    #   gcc = {
    #     arch = "x86-64-v3";
    #     tune = "native";
    #   };

    #   system = "x86_64-linux";
    # };

    overlays = with inputs; [
      nix-cachyos-kernel.overlays.pinned
    ];
  };

  # enable rgb support
  services.hardware.openrgb.enable = true;

  # enable ddcutil
  users.users = lib.genAttrs users (name: {
    extraGroups = [
      "i2c"
      "uinput"
    ];
  });
}
