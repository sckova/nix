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

  # fixes a regression that crashes firefox by upgrading
  # from 25.3.1 to 25.3.2 (very unstable)
  # https://github.com/nix-community/nixos-apple-silicon/issues/380
  nixpkgs.overlays = [
    (final: prev: {
      mesa = prev.mesa.overrideAttrs (oldAttrs: {
        version = "25.3.2";
        src = prev.fetchFromGitLab {
          domain = "gitlab.freedesktop.org";
          owner = "mesa";
          repo = "mesa";
          rev = "11000ba6afe0f32cbeed45d4db3c65ff51487dec";
          hash = "sha256-YZg17uATScPwjUEEMEuY3NFNdpMdOOYbD6Zoh5psl6I=";
        };
      });
    })
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
      size = 16000; # 16GB
    }
  ];

  security.sudo.wheelNeedsPassword = false;
}
