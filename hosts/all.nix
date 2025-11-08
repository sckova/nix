# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.sckova = {
    imports = [
      ../home/all.nix
      ../home/${config.networking.hostName}.nix
    ];
  };

  boot = {

    plymouth = {
      enable = true;
    };

    loader = {
      timeout = 3;
      systemd-boot = {
        enable = true;
        configurationLimit = null;
      };
      efi = {
        canTouchEfiVariables = false;
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
      "apple_dcp.show_notch=1"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  networking.networkmanager.enable = true;
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

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
    };
    libinput.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.sckova = {
    isNormalUser = true;
    description = "Sean Kovacs";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    hashedPassword = "$6$bvwRUFaJNMpH8rm3$FGDWFN6tBScJ/2DynAjnlZE8JRfyADN78d6c4GawxpAjyNLNE/AjQzMA09tLRqpKX7WnN5PIUZLAm2bT9/RbG0";
  };

  security.sudo.wheelNeedsPassword = false;

  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.gtk.global-menu.enabled" = true;
      "widget.gtk.global-menu.wayland.enabled" = true;
      "browser.tabs.inTitlebar" = 0;
      "extensions.pocket.enabled" = false;
      "extensions.screenshots.disabled" = true;
      "browser.topsites.contile.enabled" = false;
      "browser.formfill.enable" = false;
      "browser.search.suggest.enabled" = false;
      "browser.search.suggest.enabled.private" = false;
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.showSearchSuggestionsFirst" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.feeds.snippets" = false;
      "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
      "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
      "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
      "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.system.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    };
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxScreenshots = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "newtab"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      SearchBar = "unified"; # alternative: "separate"

      # ---- EXTENSIONS ----
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
      # ExtensionSettings = {
      #   # blocks all addons except the ones specified below
      #   "*".installation_mode = "blocked";
      #   "uBlock0@raymondhill.net" = {
      #     install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      #     installation_mode = "force_installed";
      #   };
      #   "plasma-browser-integration@kde.org" = {
      #     install_url = "https://addons.mozilla.org/firefox/downloads/latest/plasma-integration/latest.xpi";
      #     installation_mode = "force_installed";
      #   };
      # };
    };
  };

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      git
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
