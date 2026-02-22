{
  pkgs,
  ...
}:
{
  systemd.user.services.wbg-daemon = {
    Unit.Description = "Wallpaper service using wbg (daemon)";
    Service.ExecStart = ''
      ${pkgs.wbg}/bin/wbg -s \
      %h/.local/share/wallpaper/daily.jpg
    '';
    Install.WantedBy = [ "niri.service" ];
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
          OUT="$HOME/.local/share/wallpaper/daily.jpg"
          API=$(wget -qO- "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&mkt=en-US&n=1")
          BASE=$(echo "$API" | jq -r '.images[0].urlbase')
          TITLE=$(echo "$API" | jq -r '.images[0].title')

          mkdir -p "$HOME/.local/share/wallpaper"
          wget -qO "$OUT" "https://www.bing.com''${BASE}_UHD.jpg"

          notify-send \
            -a "Wallpaper of the day" \
            -u low \
            -i preferences-desktop-wallpaper \
            "$TITLE"
        '';
      }
    );
    Service.ExecStartPost = "${pkgs.systemd}/bin/systemctl --user restart wbg-daemon.service";
    Install.WantedBy = [ "niri.service" ];
  };

  systemd.user.timers.bing-wallpaper = {
    Unit.Description = "Run bing wallpaper retrieval daily";
    Timer.OnCalendar = "*-*-* 10:00:00 GMT";
    Timer.Persistent = true;
    Install.WantedBy = [ "timers.target" ];
  };
}
