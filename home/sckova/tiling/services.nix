# home/sckova/tiling/services.nix
{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
{

  services.tailscale-systray = {
    enable = true;
    theme = "dark:nobg";
  };

  systemd.user.services = {
    niri-poweroff-display = {
      Install.WantedBy = [ "niri.service" ];

      Service = {
        ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "niri-poweroff-display";

            text = /* bash */ ''
              NIRI_SOCKET=$(find '/run/user/1000/niri.wayland'*'.sock' | head -n 1)
              export NIRI_SOCKET
              echo "using socket: $NIRI_SOCKET"
              echo "powering off monitors..."
              niri msg action power-off-monitors
            '';
          }
        );

        Restart = "on-failure";
        Type = "oneshot";
      };

      Unit = {
        After = [ "niri.service" ];
        Description = "Power off displays at login";
        PartOf = [ "niri.service" ];
      };
    };

    noctalia = {
      Install.WantedBy = [ "niri.service" ];

      Service = {
        ExecStart = lib.getExe config.programs.noctalia.package;
        Restart = "on-failure";
      };

      Unit = {
        After = [ "niri.service" ];
        Description = "Noctalia Shell - Wayland desktop shell";
        Documentation = "https://docs.noctalia.dev";
        X-Restart-Triggers = [ config.xdg.configFile."noctalia/config.toml".source ];
      };
    };

    swaylock = {
      Install.WantedBy = [ "niri.service" ];

      Service = {
        ExecStart = lib.getExe config.programs.swaylock.package;
        Restart = "on-failure";
      };

      Unit = {
        After = [ "niri.service" ];
        Description = "Screen locker";
        Documentation = "https://github.com/swaywm/swaylock";
        PartOf = [ "niri.service" ];
        X-Restart-Triggers = [ config.programs.swaylock.settings.image ];
      };
    };

    vicinae = {
      Install.WantedBy = [ "niri.service" ];

      Service = {
        ExecStart = "${lib.getExe config.programs.vicinae.package} server";
        Restart = "on-failure";
        Type = "simple";
      };

      Unit = {
        After = [ "niri.service" ];
        Description = "Application launcher daemon";
        Documentation = "https://docs.vicinae.com";
      };
    };

    # https://github.com/tbrugere/yabd/blob/main/etc/yabd.service
    yabd = lib.mkIf (osConfig.networking.hostName == "peach") {
      Install.WantedBy = [ "graphical-session.target" ];

      Service = {
        BusName = "re.bruge.yabd";

        ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "yabd";

            text = /* bash */ ''
              ${lib.getExe pkgs.yabd} run \
                --device apple-panel-bl \
                --min-brightness 5.0
            '';
          }
        );

        Restart = "on-failure";
        Type = "dbus";
      };

      Unit = {
        Description = "Yet another Brightness Daemon";
        PartOf = [ "graphical-session.target" ];
      };
    };
  };
}
