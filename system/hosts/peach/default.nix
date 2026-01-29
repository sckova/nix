{
  pkgs,
  config,
  lib,
  ...
}:
let
  asahi-artwork = pkgs.fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "artwork";
    rev = "80d14f8b6f485b310e305a84b4b806361518ddd1";
    hash = "sha256-1r7gPFsn3GmKO4YsixsK7eyQWfVjsWnuOEtSCQequn8=";
  };
in
{
  boot = {
    kernelParams = [ "appledrm.show_notch=1" ];
    m1n1CustomLogo = "${asahi-artwork}/logos/png_256/AsahiLinux_logomark.png";
    plymouth.logo = lib.mkForce "${asahi-artwork}/logos/png_64/AsahiLinux_logomark.png";
  };

  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/login-screen".logo =
        "${asahi-artwork}/logos/svg/AsahiLinux_logo_horizontal_darkbg.svg";
    }
  ];

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
      hash = "sha256-ooBrgsZ+B6Fmoy6Ze5ppP9oKQzMIk1orvx+ldxY6bQs=";
      message = ''
        you need to add the firmware to the store:
        mkdir system/hosts/peach/firmware
        sudo cp -r /mnt/boot/asahi/{all_firmware.tar.gz,kernelcache*} system/hosts/peach/firmware
        nix-store --add-fixed sha256 --recursive ./system/hosts/peach/firmware
      '';
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
