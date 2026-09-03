# system/services/tiling.nix
{
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.tuigreet ];

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    niri.enable = true;
  };

  security.pam.services = {
    niri.enableGnomeKeyring = true;

    swaylock = {
      enableGnomeKeyring = true;
      gnupg.enable = true;
    };
  };

  services = {
    gnome.gnome-keyring.enable = true;

    greetd = {
      enable = true;

      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
          user = "greeter";
        };

        initial_session = {
          command = "${pkgs.niri}/bin/niri-session";
          user = "sckova";
        };
      };
    };
  };
}
