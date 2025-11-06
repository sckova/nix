{ config, pkgs, lib, catppuccin, ... }: {
  networking.hostName = "peach";

  catppuccin.accent = "peach";

  home-manager.users.sckova = {
    imports = [ catppuccin.homeModules.catppuccin ];
  };

  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    extractPeripheralFirmware = true;
    peripheralFirmwareDirectory = ../firmware;
  };

  swapDevices = [{
    device = "/swapfile";
    size = 32000; # 32GB
  }];
}

