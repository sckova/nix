{
  config,
  pkgs,
  lib,
  catppuccin,
  ...
}:
{
  networking.hostName = "peach";

  boot.binfmt.emulatedSystems = [
    "x86_64-linux"
    "riscv64-linux"
  ];

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
    peripheralFirmwareDirectory = pkgs.requireFile {
      name = "firmware";
      hashMode = "recursive";
      hash = "sha256-lw8tJHRUSBwqu82ys4rZIYH0sEb+dDjQkXg1wt1afZI=";
      message = ''
        nix-store --add-fixed sha256 --recursive ./firmware
      '';
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 32000; # 32GB
    }
  ];

  security.sudo.wheelNeedsPassword = false;
}
