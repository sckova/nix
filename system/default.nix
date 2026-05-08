# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  hostname,
  users,
  inputs,
  ...
}:
{
  imports = [
    ../lib/nix-settings.nix
    ../lib/users.nix
    ../lib/options.nix
    ../lib/sops.nix
    ./searxng
    ./games
    ./widevine
    ./shell/fish.nix
    ./tailscale
  ];

  networking.hostName = hostname;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.niri-flake.overlays.niri
    inputs.noctalia.overlays.default
    inputs.nur.overlays.default
    (import ../packages/overlay.nix inputs)
  ];

  # This replaces the giant block that used to be in your flake
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # This passes hostname and inputs down to home/default.nix
    extraSpecialArgs = { inherit hostname inputs; };

    users = pkgs.lib.genAttrs users (user: {
      imports = [
        ../home
        ../home/${user}
        ../home/${user}/hosts/${hostname}
      ];
    });

    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.base16.nixosModule
      (
        { config, ... }:
        {
          scheme = "${inputs.tt-schemes}/base24/${config.colors.scheme}.yaml";
        }
      )
      inputs.noctalia.homeModules.default
      inputs.nixvim.homeModules.nixvim
    ];
  };

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
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
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

  services = {
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "sckova";
      defaultSession = "niri";
      sddm.enable = true;
      sddm.wayland.enable = true;
    };
    gnome.gnome-keyring.enable = true;
    libinput.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      systemWide = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    udisks2.enable = true;
    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    openssh.enable = true;
    glances.enable = true;
    glances.package = pkgs.glances.overrideAttrs (oldAttrs: {
      disabledTests = (oldAttrs.disabledTests or [ ]) ++ [
        "test_phys_core_returns_int"
      ];
    });
  };

  environment.systemPackages = with pkgs; [
    git
    firefoxpwa
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    })
  ];

  security = {
    pam.services = {
      niri.enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;
      swaylock = {
        name = "swaylock";
        enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;
        gnupg.enable = true;
        gnupg.noAutostart = true;
      };
    };
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
  };

  networking = {
    firewall.enable = false;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    hosts = {
      "192.168.1.64" = [
        "kube1"
        "kube1.local"
        "kube1.attlocal.net"
      ];
      "192.168.1.65" = [
        "kube2"
        "kube2.local"
        "kube2.attlocal.net"
      ];
      "192.168.1.66" = [
        "kube3"
        "kube3.local"
        "kube3.attlocal.net"
        "kube3.taila30609.ts.net"
      ];
      "192.168.1.67" = [
        "kube4"
        "kube4.local"
        "kube4.attlocal.net"
      ];
    };
  };

  documentation.man.enable = true;
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
  system.stateVersion = "26.05"; # Did you read the comment?
}
