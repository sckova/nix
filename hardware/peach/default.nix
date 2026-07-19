{
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
let
  appleRainbow-png =
    pkgs.runCommand "apple-rainbow.png"
      {
        nativeBuildInputs = [ pkgs.librsvg ];
      }
      ''
        rsvg-convert -w 256 -h 256 ${appleRainbow-svg} -o $out
      '';
  appleRainbow-svg = pkgs.fetchurl {
    sha256 = "sha256-6uXWL3oM9GvwSMLloY1P5P28xkVzIV5N6QeOd3HeDRM=";
    url = "https://upload.wikimedia.org/wikipedia/commons/8/84/Apple_Computer_Logo_rainbow.svg";
  };
in
{
  imports = with inputs; [
    (modulesPath + "/installer/scan/not-detected.nix")
    apple-silicon.nixosModules.default
  ];

  boot = {
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [
        "usb_storage"
        "sdhci_pci"
      ];

      kernelModules = [ ];
    };

    kernel.sysctl = {
      "vm.max_map_count" = 1048576;
      "vm.page-cluster" = 0;
      # (cont.) enable zswap
      "vm.swappiness" = 100;
      "vm.watermark_scale_factor" = 125;
    };

    kernelModules = [ ];

    kernelParams = [
      # enable zswap (mirrored from fedora asahi remix)
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.zpool=zsmalloc"
      "zswap.max_pool_percent=20"

      # enable the notch
      "appledrm.show_notch=1"
    ];

    # thank you to u/douv:
    # https://www.reddit.com/r/AsahiLinux/comments/1sb8cby/retro_boot_logo/
    m1n1CustomLogo = appleRainbow-png;

    plymouth = lib.mkForce {
      enable = true;

      extraConfig = ''
        DeviceScale=1
      '';

      theme = "seamless-asahi";

      themePackages = [
        (inputs.seamless-asahi-plymouth.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
          logo = appleRainbow-png;
        })
      ];
    };
  };

  fileSystems = {
    "/" = {
      options = [
        "subvol=root"
        "compress=zstd"
        "relatime"
      ];

      fsType = "btrfs";
      label = "nixos";
    };

    "/boot" = {
      options = [
        "fmask=0022"
        "dmask=0022"
        "umask=0077"
      ];

      fsType = "vfat";
      label = "efi";
    };

    "/home" = {
      options = [
        "subvol=home"
        "compress=zstd"
        "relatime"
      ];

      fsType = "btrfs";
      label = "nixos";
    };

    "/nix" = {
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime"
      ];

      fsType = "btrfs";
      label = "nixos";
    };
  };

  hardware.asahi = {
    enable = true;

    # https://github.com/nix-community/nixos-apple-silicon/issues/299#issuecomment-2901508921
    peripheralFirmwareDirectory = pkgs.requireFile {
      hash = "sha256-7Au5t58dBIkZdPoa58Vc3LjSHljiI7L7I3YfuPCvlYI=";
      hashMode = "recursive";

      message = /* bash */ ''
        # you need to add the firmware to the store:
        mkdir hardware/peach/firmware
        sudo cp -v /mnt/boot/vendorfw/firmware.cpio hardware/peach/firmware
        nix-store --add-fixed sha256 --recursive ./hardware/peach/firmware
        nix hash path hardware/peach/firmware
      '';

      name = "firmware";
    };

    setupAsahiSound = true;
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "aarch64-linux";

    overlays = [
      inputs.apple-silicon.overlays.apple-silicon-overlay
      (final: prev: {
        uboot-asahi = prev.uboot-asahi.overrideAttrs (old: {
          postConfigure = (old.postConfigure or "") + ''
            cat >> .config <<'EOF'
            # CONFIG_VIDEO_LOGO is not set
            CONFIG_DISPLAY_BOARDINFO_LATE=n
            CONFIG_BOOTDELAY=0
            CONFIG_SILENT_CONSOLE=y
            CONFIG_PREBOOT="setenv silent 1"
            EOF

            # Regenerate the configuration with new flags
            make olddefconfig
          '';
        });
      })
    ];
  };

  swapDevices = [ { label = "swap"; } ];
}
