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

  boot.kernelParams = [ "apple_dcp.show_notch=1" ];

  catppuccin.accent = "peach";

  home-manager.users.sckova = {
    imports = [ catppuccin.homeModules.catppuccin ];
  };

  hardware.asahi = {
    enable = true;
    setupAsahiSound = true;
    # https://github.com/nix-community/nixos-apple-silicon/issues/299#issuecomment-2901508921
    peripheralFirmwareDirectory = pkgs.requireFile {
      name = "firmware";
      hashMode = "recursive";
      hash = "sha256-lw8tJHRUSBwqu82ys4rZIYH0sEb+dDjQkXg1wt1afZI=";
      message = ''
        nix-store --add-fixed sha256 --recursive ./firmware
      '';
    };
  };

  # hardware.graphics.package =
  #   # Workaround for Mesa 25.3.0 regression
  #   # https://github.com/nix-community/nixos-apple-silicon/issues/380
  #   assert pkgs.mesa.version == "25.3.0";
  #   (import (fetchTarball {
  #     url = "https://github.com/NixOS/nixpkgs/archive/c5ae371f1a6a7fd27823bc500d9390b38c05fa55.tar.gz";
  #     sha256 = "sha256-4PqRErxfe+2toFJFgcRKZ0UI9NSIOJa+7RXVtBhy4KE=";
  #   }) { localSystem = pkgs.stdenv.hostPlatform; }).mesa;

  swapDevices = [
    {
      device = "/swapfile";
      size = 16000; # 16GB
    }
  ];

  security.sudo.wheelNeedsPassword = false;
}
