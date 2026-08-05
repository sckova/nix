{
  config,
  pkgs,
  ...
}:
{
  systemd.user = {
    services = {
      bing-wallpaper = {
        Service = {
          ExecStart = pkgs.lib.getExe (
            pkgs.writeShellApplication {
              name = "bing-wallpaper";

              runtimeInputs = with pkgs; [
                wget
                jq
                coreutils
                libnotify
              ];

              text = /* bash */ ''
                while ! wget -q --spider https://www.bing.com; do
                  sleep 1
                done

                OUT="$HOME/.local/share/wallpaper/daily.jpg"
                API=$(wget -qO- "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&mkt=en-US&n=1")
                API_JQ=$(echo "$API" | jq)
                BASE=$(echo "$API" | jq -r '.images[0].urlbase')
                TITLE=$(echo "$API" | jq -r '.images[0].title')

                mkdir -p "$HOME/.local/share/wallpaper"
                wget -qO "$OUT" "https://www.bing.com''${BASE}_UHD.jpg"
                printf "%s" "$API_JQ" > "$HOME/.local/share/wallpaper/meta.json"

                notify-send \
                  -a "Wallpaper of the day" \
                  -u low \
                  -i preferences-desktop-wallpaper \
                  "$TITLE"
              '';
            }
          );

          ExecStartPost = "${pkgs.systemd}/bin/systemctl --user start gowall-convert.service";
          Restart = "on-failure";
          RestartSec = "5s";
          Type = "oneshot";
        };

        Unit = {
          Description = "Download and set Bing wallpaper of the day";
          StartLimitBurst = 6;
          StartLimitIntervalSec = "10m";
        };
      };

      gowall-convert = {
        Install.WantedBy = [ "niri.service" ];

        Service = {
          ExecStart = pkgs.lib.getExe (
            pkgs.writeShellApplication {
              name = "gowall-convert";
              runtimeInputs = with pkgs; [ gowall ];

              text = /* bash */ ''
                gowall convert \
                  ${config.xdg.dataHome}/wallpaper/daily.jpg \
                  --output ${config.xdg.dataHome}/wallpaper/daily-colored.jpg \
                  -t nix
              '';
            }
          );

          ExecStartPost = pkgs.lib.getExe (
            pkgs.writeShellApplication {
              name = "gowall-convert-post";
              runtimeInputs = with pkgs; [ systemd ];

              text = /* bash */ ''
                systemctl --user restart wbg-daemon.service
                systemctl --user restart swaylock.service
              '';
            }
          );

          Restart = "on-failure";
          RestartSec = "10s";
          Type = "oneshot";
        };

        Unit = {
          Description = "Convert a wallpaper to the system color scheme";
          StartLimitBurst = 6;
          StartLimitIntervalSec = "10m";
        };
      };

      wbg-daemon = {
        Service.ExecStart = /* bash */ ''
          ${pkgs.wbg}/bin/wbg -s \
          %h/.local/share/wallpaper/daily-colored.jpg
        '';

        Unit = {
          After = [ "niri.service" ];
          Description = "Wallpaper service using wbg (daemon)";
          X-RestartIfChanged = false;
          X-SwitchMethod = "keep-old";
        };
      };
    };

    timers.bing-wallpaper = {
      Install.WantedBy = [ "timers.target" ];

      Timer = {
        OnCalendar = "*-*-* 10:00:00 GMT";
        Persistent = true;
      };

      Unit.Description = "Run bing wallpaper retrieval daily";
    };
  };

  xdg.configFile."gowall/config.yml".source = (pkgs.formats.yaml { }).generate "gowall-config" {
    themes = [
      {
        colors = with config.scheme.withHashtag; [
          base00
          base01
          base02
          base03
          base04
          base05
          base06
          base07
          base08
          base09
          base0A
          base0B
          base0C
          base0D
          base0E
          base0F
          base10
          base11
          base12
          base13
          base14
          base15
          base16
          base17
        ];

        name = "nix";
      }
    ];
  };
}
