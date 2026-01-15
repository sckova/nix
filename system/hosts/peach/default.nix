{pkgs, ...}: {
  boot.kernelParams = ["appledrm.show_notch=1"];

  catppuccin = {
    accent = "lavender";
    flavor = "macchiato";
  };

  services.displayManager.gdm.enable = true;

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
      size = 8000; # 8GB
    }
  ];

  security.sudo.wheelNeedsPassword = false;
}
