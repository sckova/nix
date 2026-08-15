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
      # resume playback later
      {
        resume-playback = true;
        save-position-on-quit = true;
        watch-later-directory = "~~state/watch_later";
      }
      # yt-dlp setup
      // {
        ytdl-format = "bestvideo/best+bestaudio/best";
        ytdl-raw-options = "cookies-from-browser=firefox";
      }
      # cache
      // {
        cache = true;
        demuxer-max-back-bytes = "128MiB";
        demuxer-max-bytes = "512MiB";
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
          hwdec = lib.mkIf (hostname != "peach") "auto-safe"; # TODO: requires AVD on peach
          title = "\${filename} - mpv (nix)"; # allows niri to match window
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
