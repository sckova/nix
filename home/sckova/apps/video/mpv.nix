# home/sckova/apps/video/mpv.nix
{
  config,
  lib,
  pkgs,
  hostname,
  isLinux,
  ...
}:
{
  home.packages = [ config.fonts.sans.package ];

  programs.mpv = {
    # split is done for organization
    config =
      with config.scheme.withHashtag;
      # enable ipc server for nautilus picker
      {
        input-ipc-server = "/tmp/mpvsocket";
      }
      # yt-dlp setup
      // {
        ytdl-format = "best";

        ytdl-raw-options = lib.concatStringsSep "," (
          lib.mapAttrsToList (key: value: "${key}=${value}") {
            concurrent-fragments = "4"; # helps with quality-menu plugin
            cookies-from-browser = "firefox"; # youtube requires auth nowadays
            fragment-retries = "infinite"; # helps with youtube-upnext plugin
            retries = "infinite"; # helps with youtube-upnext plugin
          }
        );
      }
      # cache
      // {
        cache = true; # enable cache
        demuxer-max-back-bytes = "128MiB"; # keep this amount of past stream
        demuxer-max-bytes = "512MiB"; # keep this amount of total stream
        demuxer-seekable-cache = "yes";
      }
      # gpu-next fancy bits
      // {
        correct-downscaling = true;
        cscale = "ewa_lanczossharp";
        dscale = "mitchell";
        scale = "ewa_lanczossharp";
        sigmoid-upscaling = true;
        vo = "gpu-next";
      }
      # linux-specific
      // lib.optionalAttrs isLinux (
        # hardware-accel and niri
        {
          gpu-context = "wayland"; # fixes issues with transparency
          title = "\${filename} - mpv (nix)"; # allows niri to match window
        }
        // lib.optionalAttrs (hostname != "peach") {
          hwdec = "auto-safe"; # TODO: requires AVD on peach
        }
      )
      # theme setup
      // {
        background-color = "#e6" + config.scheme.base00;
        osd-back-color = base11;
        osd-border-color = base11;
        osd-color = base05;
        osd-font = config.fonts.sans.name;
        osd-shadow-color = base00;
        sub-font = config.fonts.sans.name;
      };

    enable = true;

    bindings =
      let
        # use system keys on each OS
        meta = if !isLinux then "super" else "ctrl";
        socket = config.programs.mpv.config.input-ipc-server;
      in
      {
        # open link input
        "${meta}+l" = "run '${
          pkgs.writeShellScript "mpv-link-picker" /* bash */ ''
            ${
              if isLinux then
                /* bash */ ''
                  LINK="$(${pkgs.zenity}/bin/zenity \
                    --entry \
                    --title="Open URL" \
                    --text="Enter media link:" \
                    2>/dev/null || true)"
                ''
              else
                /* bash */ ''
                  LINK="$(/usr/bin/osascript -e \
                    'text returned of (display dialog "Enter media link:" default answer "")' \
                    2>/dev/null || true)"
                ''
            }

            if [ -n "$LINK" ] && [ -S "${socket}" ]; then
              echo "loadfile \"$LINK\"" \
                | ${pkgs.socat}/bin/socat - UNIX-CONNECT:"${socket}"
            fi
          ''
        }'";

        # open file picker
        "${meta}+o" = "run '${
          pkgs.writeShellScript "mpv-picker" /* bash */ ''
            ${
              if isLinux then
                /* bash */ ''
                  FILE="$(${pkgs.zenity}/bin/zenity \
                    --file-selection \
                    2>/dev/null || true)"
                ''
              else
                /* bash */ ''
                  FILE="$(/usr/bin/osascript -e \
                    'POSIX path of (choose file with prompt "Select Media:")' \
                    2>/dev/null || true)"
                ''
            }

            if [ -n "$FILE" ] && [ -S "${socket}" ]; then
              echo "loadfile \"$FILE\"" \
                | ${pkgs.socat}/bin/socat - UNIX-CONNECT:"${socket}"
            fi
          ''
        }'";
      };

    scriptOpts.uosc = {
      color =
        with config.scheme;
        lib.concatStringsSep "," (
          lib.mapAttrsToList (key: value: "${key}=${value}") {
            background = base00;
            background_text = base05;
            curtain = base10;
            error = base08;
            foreground = config.scheme.${config.colors.accent};
            foreground_text = base01;
            success = base0B;
          }
        );

      window_border_size = 0;
    };

    scripts =
      with pkgs.mpvScripts;
      [
        uosc
        mpv-subtitle-lines # requires uosc
        autosub
        twitch-chat

        # youtube plugins
        quality-menu
        sponsorblock
        youtube-upnext
        youtube-chat
      ]
      ++ lib.optionals isLinux [
        mpris
        mpv-notify-send
      ];
  };
}
