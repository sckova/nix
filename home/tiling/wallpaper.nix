{
  pkgs,
  config,
  ...
}: let
  script = pkgs.writeShellScript "bing-wallpaper" ''
    set -euo pipefail

    # Configuration
    SIZE="UHD"
    MARKET="en-US"
    OUTPUT_PATH="''${XDG_DATA_HOME:-$HOME/.local/share}/wallpaper/daily.jpg"
    DAY="0"

    # API configuration
    BING="https://www.bing.com"
    API="/HPImageArchive.aspx"
    REQ_IMG="$BING$API?format=js&idx=$DAY&mkt=$MARKET&n=1"

    echo "Pinging Bing API..."

    # Fetch API response
    API_RESP=$(${pkgs.wget}/bin/wget --quiet --output-document=- "$REQ_IMG")
    if (( $? > 0 )); then
      echo "Ping failed!"
      exit 1
    fi

    # Extract image URL base
    URL_BASE=$(echo "$API_RESP" | ${pkgs.gnugrep}/bin/grep -oP 'urlbase":"[^"]*' | ${pkgs.coreutils}/bin/cut -d '"' -f 3)
    REQ_IMG_URL="$BING$URL_BASE\_$SIZE.jpg"

    # Extract title
    TITLE=$(echo "$API_RESP" | ${pkgs.gnugrep}/bin/grep -oP 'title":"[^"]*' | ${pkgs.coreutils}/bin/cut -d '"' -f 3)
    echo "Bing Image of the day: $TITLE"

    # Check if specific size exists, fallback to default
    if ! ${pkgs.wget}/bin/wget --quiet --spider --max-redirect 0 "$REQ_IMG_URL"; then
      REQ_IMG_URL="$BING$(echo "$API_RESP" | ${pkgs.gnugrep}/bin/grep -oP 'url":"[^"]*' | ${pkgs.coreutils}/bin/cut -d '"' -f 3)"
    fi

    echo "$REQ_IMG_URL"

    # Extract filename
    IMG_NAME="''${REQ_IMG_URL##*/}"
    IMG_NAME="''${IMG_NAME#th?id=OHR.}"
    IMG_NAME="''${IMG_NAME%&rf=*}"
    echo "$IMG_NAME"

    # Create parent directory
    ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname "$OUTPUT_PATH")"

    # Download image, overwrite if exists
    ${pkgs.wget}/bin/wget --quiet --output-document="$OUTPUT_PATH" "$REQ_IMG_URL"
    echo "Wallpaper saved to $OUTPUT_PATH"

    # Send notification
    if command -v ${pkgs.libnotify}/bin/notify-send &> /dev/null; then
      ${pkgs.libnotify}/bin/notify-send -u low -t 10000 -i preferences-desktop-wallpaper \
        "Bing Wallpaper of the Day" "$TITLE"
    fi

    echo "Wallpaper downloaded and applied successfully."
  '';
in {
  home.packages = with pkgs; [
    wpaperd
  ];

  home.file.".config/wpaperd/config.toml" = {
    text = ''
      [default]
      mode = "center"

      [any]
      path = "/home/${config.userOptions.username}/.local/share/wallpaper/daily.jpg"
    '';
    force = true;
  };

  systemd.user.services.wpaperd = {
    Unit = {
      Description = "Modern wallpaper daemon for Wayland";
      PartOf = ["niri.service"];
      Requires = ["niri.service"];
      After = ["niri.service"];
    };
    Service = {
      ExecStart = "${pkgs.wpaperd}/bin/wpaperd";
    };
    Install = {
      WantedBy = [
        "niri.service"
      ];
    };
  };

  systemd.user.services.bing-wallpaper = {
    Unit = {
      Description = "Download and set Bing wallpaper of the day";
      After = [
        "network-online.target"
      ];
      Wants = [
        "network-online.target"
      ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${script}";
      ExecStartPost = "${pkgs.systemd}/bin/systemctl --user restart wpaperd.service";
    };

    Install = {
      WantedBy = [
        "niri.service"
      ];
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
      WantedBy = ["timers.target"];
    };
  };
}
