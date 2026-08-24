# home/sckova/apps/video/streamlink.nix
{
  config,
  lib,
  pkgs,
  isLinux,
  ...
}:
let
  cookiesFile = "${config.xdg.dataHome}/cookies.txt";

  exportCookies = pkgs.writeShellScript "export-streamlink-cookies" /* bash */ ''
    set -e

    # Ensure target directory exists
    ${pkgs.coreutils}/bin/mkdir -p "$(${pkgs.coreutils}/bin/dirname "${cookiesFile}")"

    # Resolve correct profile path dynamically
    FF_DIR="${
      if isLinux then
        "/home/sckova/.config/mozilla/firefox"
      else
        "/Users/sckova/Library/Application Support/Firefox/Profiles"
    }"

    # 1. Enforce strict exit if the base directory is missing
    if [ ! -d "$FF_DIR" ]; then
      echo "FATAL: Firefox profile directory not found at $FF_DIR" >&2
      exit 1
    fi

    # 2. Locate most recently updated SQLite db. 
    COOKIE_DB=$(${pkgs.findutils}/bin/find -L "$FF_DIR" -name "cookies.sqlite" -type f -printf "%T@ %p\n" 2>/dev/null | ${pkgs.coreutils}/bin/sort -n | ${pkgs.coreutils}/bin/tail -1 | ${pkgs.coreutils}/bin/cut -d" " -f2-)

    # 3. Enforce strict exit if the database query returns empty
    if [ -z "$COOKIE_DB" ]; then
      echo "FATAL: Could not locate cookies.sqlite inside $FF_DIR" >&2
      exit 1
    fi

    echo "INFO: Extracting cookies from $COOKIE_DB"

    TMP_DB=$(${pkgs.coreutils}/bin/mktemp)
    ${pkgs.coreutils}/bin/cp "$COOKIE_DB" "$TMP_DB"

    echo "# Netscape HTTP Cookie File" > "${cookiesFile}"

    ${pkgs.sqlite}/bin/sqlite3 -separator "$(${pkgs.coreutils}/bin/printf '\t')" "$TMP_DB" \
      "SELECT host, CASE SUBSTR(host, 1, 1) WHEN '.' THEN 'TRUE' ELSE 'FALSE' END, path, CASE isSecure WHEN 1 THEN 'TRUE' ELSE 'FALSE' END, expiry, name, value FROM moz_cookies;" \
      >> "${cookiesFile}"
      
    ${pkgs.coreutils}/bin/rm -f "$TMP_DB"

    echo "SUCCESS: Cookies exported to ${cookiesFile}"
  '';
in
{
  programs.streamlink = {
    enable = true;

    settings = {
      default-stream = "best";
      ffmpeg-ffmpeg = lib.getExe pkgs.ffmpeg;
      http-cookies-file = cookiesFile;
      player = "/etc/profiles/per-user/sckova/bin/mpv";
      retry-max = 10;
      title = "streamlink";
    };
  };
}
// lib.optionalAttrs isLinux ({
  systemd.user.services.streamlink-firefox-cookies = lib.mkIf isLinux {
    Install.WantedBy = [ "default.target" ];

    Service = {
      ExecStart = "${exportCookies}";
      Type = "oneshot";
    };

    Unit = {
      After = [ "graphical-session.target" ];
      Description = "Export Firefox cookies for Streamlink";
    };
  };
})
// lib.optionalAttrs (!isLinux) ({
  launchd.agents.streamlink-firefox-cookies = {
    config = {
      ProgramArguments = [ "${exportCookies}" ];
      RunAtLoad = true;
    };

    enable = true;
  };
})
