{
  config,
  lib,
  pkgs,
  hostname,
  isLinux,
  ...
}:
{
  imports = [
    ./${hostname}
  ];

  boot = lib.mkIf isLinux {
    consoleLogLevel = 0;
    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];

    loader = {
      systemd-boot.enable = true;
      timeout = 0;
    };

    plymouth = {
      enable = true;
      logo = "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
    };
  };

  hardware = lib.mkIf isLinux {
    bluetooth.enable = true;
    graphics.enable = true;
  };
}
