{
  pkgs,
  config,
  ...
}:
{
  systemd.user.services.wbg-daemon = {
    Unit = {
      Description = "Wallpaper service using wbg (daemon)";
      After = [ "graphical-session.target" ];
      X-RestartIfChanged = false;
      X-SwitchMethod = "keep-old";
    };
    Service.ExecStart = /* bash */ ''
      ${pkgs.wbg}/bin/wbg -s \
      %h/.local/share/wallpaper/daily-colored.jpg
    '';
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.bing-wallpaper = {
    Unit.Description = "Download and set Bing wallpaper of the day";
    Unit.StartLimitBurst = 6;
    Unit.StartLimitIntervalSec = "10m";
    Service.Restart = "on-failure";
    Service.RestartSec = "5s";
    Service.Type = "oneshot";
    Service.ExecStart = pkgs.lib.getExe (
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
    Service.ExecStartPost = "${pkgs.systemd}/bin/systemctl --user start gowall-convert.service";
  };

  systemd.user.timers.bing-wallpaper = {
    Unit.Description = "Run bing wallpaper retrieval daily";
    Timer.OnCalendar = "*-*-* 10:00:00 GMT";
    Timer.Persistent = true;
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services.gowall-convert = {
    Unit.Description = "Convert a wallpaper to the system color scheme";
    Unit.StartLimitBurst = 6;
    Unit.StartLimitIntervalSec = "10m";
    Service.Restart = "on-failure";
    Service.RestartSec = "10s";
    Service.Type = "oneshot";
    Service.ExecStart = /* bash */ ''
      ${pkgs.gowall}/bin/gowall convert \
      %h/.local/share/wallpaper/daily.jpg \
      --output %h/.local/share/wallpaper/daily-colored.jpg \
      -t nix
    '';
    Service.ExecStartPost = "${pkgs.systemd}/bin/systemctl --user restart wbg-daemon.service";
  };

  home.file.".config/gowall/config.yml".text = with config.scheme.withHashtag; /* yaml */ ''
    themes:
      - name: "nix"
        colors:
          - "${base00}"
          - "${base01}"
          - "${base02}"
          - "${base03}"
          - "${base04}"
          - "${base05}"
          - "${base06}"
          - "${base07}"
          - "${base08}"
          - "${base09}"
          - "${base0A}"
          - "${base0B}"
          - "${base0C}"
          - "${base0D}"
          - "${base0E}"
          - "${base0F}"
          - "${base10}"
          - "${base11}"
          - "${base12}"
          - "${base13}"
          - "${base14}"
          - "${base15}"
          - "${base16}"
          - "${base17}"
          - "${base17}"
          - "${base17}"
  '';
}
