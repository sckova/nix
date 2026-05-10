{
  pkgs,
  config,
  hostname,
  ...
}:
{
  imports = [
    ./${hostname}
  ];

  boot = {
    plymouth.enable = true;
    plymouth.logo = "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
    };
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
  };
}
