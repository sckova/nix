# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}:
{
  boot = {
    plymouth.enable = true;
    plymouth.logo = "${pkgs.nixos-icons}/share/icons/hicolor/64x64/apps/nix-snowflake-white.png";
    loader = {
      timeout = 3;
      limine = {
        enable = true;
        maxGenerations = 10;
        extraConfig = ''
          timeout: 3
        '';
        style = {
          wallpapers = [ ];
          wallpaperStyle = "stretched";
          backdrop = "#1e1e2e";
          interface = {
            branding = "kova's nixos!";
            brandingColor = 5;
          };
        };
      };
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

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    niri.enable = true;
    niri.package = pkgs.niri-unstable;
    dconf.enable = true;
    dconf.profiles.user = {
      databases = [
        {
          # breaks user-level indirect config of dconf
          # lockAll = true;
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              clock-format = "12h";
              clock-show-weekday = true;
            };
            "org/gnome/desktop/wm/preferences" = {
              button-layout = ":";
              action-double-click-titlebar = "'none'";
            };
            "org/gnome/desktop/media-handling" = {
              automount = false;
              automount-open = false;
              autorun-never = true;
            };
            "org/gnome/settings-daemon/plugins/power" = {
              sleep-inactive-ac-type = "nothing";
            };
            "org/gnome/mutter" = {
              edge-tiling = true;
              dynamic-workspaces = true;
              experimental-features = [ "variable-refresh-rate" ];
            };
          };
        }
      ];
    };

  };

  # aerothemeplasma = {
  #   enable = true;
  #   plasma.enable = true;
  #   fonts.enable = false;
  #   plymouth.enable = false;
  #   sddm.enable = true;
  # };

  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
      defaultSession = "niri";
    };
    gnome.gnome-keyring.enable = true;
    libinput.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    udisks2.enable = true;
    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    openssh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    firefoxpwa
  ];

  security.pam.services.niri.enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;
  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
  documentation.man.enable = true;
  documentation.man.generateCaches = false;
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
