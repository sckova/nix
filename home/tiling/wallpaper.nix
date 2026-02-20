{
  pkgs,
  ...
}:
{
  systemd.user.services.mpvpaper = {
    Unit = {
      Description = "Modern wallpaper daemon for Wayland";
      PartOf = [ "niri.service" ];
      Requires = [ "niri.service" ];
      After = [ "niri.service" ];
    };
    Service = {
      ExecStart = ''
        ${pkgs.mpvpaper}/bin/mpvpaper '*' \
        '/home/sckova/.local/share/wallpaper/daily.jpg' \
        -o '--keep-open=always --save-position-on-quit' \
      '';
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  systemd.user.services.bing-wallpaper = {
    Unit = {
      Description = "Download and set Bing wallpaper of the day";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "bing-wallpaper" ''
        OUT="''${XDG_DATA_HOME:-$HOME/.local/share}/wallpaper/daily.jpg"

        API_RESP=$(${pkgs.wget}/bin/wget -qO- "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&mkt=en-US&n=1") || exit 1

        URL_BASE=$(echo "$API_RESP" | ${pkgs.gnugrep}/bin/grep -oP 'urlbase":"[^"]*' | cut -d '"' -f 3)
        TITLE=$(echo "$API_RESP" | ${pkgs.gnugrep}/bin/grep -oP 'title":"[^"]*' | cut -d '"' -f 3)

        ${pkgs.coreutils}/bin/mkdir -p "$(dirname "$OUT")"
        ${pkgs.wget}/bin/wget -qO "$OUT" "https://www.bing.com$URL_BASE\_UHD.jpg" || \
          ${pkgs.wget}/bin/wget -qO "$OUT" "https://www.bing.com$(echo "$API_RESP" | ${pkgs.gnugrep}/bin/grep -oP 'url":"[^"]*' | cut -d '"' -f 3)"

        ${pkgs.libnotify}/bin/notify-send \
          -a "Bing Wallpaper Service" \
          -u low \
          -i preferences-desktop-wallpaper \
          "$TITLE"
      '';
      ExecStartPost = "${pkgs.systemd}/bin/systemctl --user restart mpvpaper.service";
    };
    Install = {
      WantedBy = [ "niri.service" ];
    };
  };

  systemd.user.timers.bing-wallpaper = {
    Unit = {
      Description = "Run bing wallpaper retrieval daily";
    };
    Timer = {
      OnCalendar = "*-*-* 10:00:00 GMT";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
