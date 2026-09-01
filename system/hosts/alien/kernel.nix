# system/hosts/alien/kernel.nix
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];

    kernelModules = [
      "i2c-dev"
      "ddcci_backlight"
    ];

    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
  };

  environment.systemPackages = with pkgs; [
    ddcutil
    openrgb
  ];

  hardware.i2c.enable = true;
  nix.settings.system-features = [ "gccarch-x86-64-v3" ];

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

  services = {
    # enable rgb support
    hardware.openrgb.enable = true;

    udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    '';
  };

  # enable ddcutil
  users.users.${config.username}.extraGroups = [
    "i2c"
    "uinput"
  ];
}
