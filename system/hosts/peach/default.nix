{
  pkgs,
  config,
  ...
}:
{
  boot.kernelParams = [ "appledrm.show_notch=1" ];

  environment.systemPackages = with pkgs; [
    ddcutil
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
  boot.kernelModules = [
    "i2c-dev"
    "ddcci_backlight"
  ];
  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';
  hardware.i2c.enable = true;

  virtualisation.docker = {
    enable = true;
    # Use the rootless mode - run Docker daemon as non-root user
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  users.users.sckova.extraGroups = [ "docker" ];

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
