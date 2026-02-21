{
  pkgs,
  ...
}:
{
  systemd.user.services.awww-daemon = {
    Unit.Description = "Wallpaper service using awww (daemon)";
    Service.ExecStart = "${pkgs.awww}/bin/awww-daemon";
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.awww-setter = {
    Unit.Description = "Wallpaper service using awww (setter)";
    Unit.Requires = [ "awww-daemon.service" ];
    Unit.After = [ "awww-daemon.service" ];
    Service.Type = "oneshot";
    Service.ExecStart = ''
      ${pkgs.awww}/bin/awww img \
      %h/.local/share/wallpaper/daily.jpg \
      --transition-step 2 \
      --transition-fps 60
    '';
  };

  systemd.user.services.bing-wallpaper = {
    Unit.Description = "Download and set Bing wallpaper of the day";
    Unit.StartLimitBurst = 6;
    Unit.StartLimitIntervalSec = "10m";
    Service.Restart = "on-failure";
    Service.RestartSec = "10s";
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
        text = ''
          set -euo pipefail

          OUT_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/wallpaper"
          OUT_FILE="$OUT_DIR/daily.jpg"

          API_URL="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&mkt=en-US&n=1"
          API_RESP=$(wget -qO- "$API_URL")

          URL_BASE=$(echo "$API_RESP" | jq -r '.images[0].urlbase')
          URL_FALLBACK=$(echo "$API_RESP" | jq -r '.images[0].url')
          TITLE=$(echo "$API_RESP" | jq -r '.images[0].title')

          mkdir -p "$OUT_DIR"

          if ! wget -qO "$OUT_FILE" "https://www.bing.com''${URL_BASE}_UHD.jpg"; then
            wget -qO "$OUT_FILE" "https://www.bing.com$URL_FALLBACK"
          fi

          notify-send \
            -a "wallpaper of the day" \
            -u low \
            -i preferences-desktop-wallpaper \
            "$TITLE"
        '';
      }
    );
    Service.ExecStartPost = "${pkgs.systemd}/bin/systemctl --user restart awww-setter.service";
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.timers.bing-wallpaper = {
    Unit.Description = "Run bing wallpaper retrieval daily";
    Timer.OnCalendar = "*-*-* 10:00:00 GMT";
    Timer.Persistent = true;
    Install.WantedBy = [ "timers.target" ];
  };
}
