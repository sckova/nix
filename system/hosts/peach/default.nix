{
  config,
  pkgs,
  lib,
  catppuccin,
  ...
}:
{
  networking.hostName = "peach";

  catppuccin.accent = "peach";

  home-manager.users.sckova = {
    imports = [ catppuccin.homeModules.catppuccin ];
  };

  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    # extractPeripheralFirmware = false;
    # This is broken because of flake git tracking.
    # I can't figure out how to make it work.
    peripheralFirmwareDirectory = ./firmware;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 32000; # 32GB
    }
  ];

  security.sudo.wheelNeedsPassword = false;
}
