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

  swapDevices = [
    {
      device = "/swapfile";
      size = 32000; # 32GB
    }
  ];

  security.sudo.wheelNeedsPassword = false;
}
