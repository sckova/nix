{
  config,
  lib,
  pkgs,
  isLinux,
  ...
}:
{
  programs.mpv = {
    config = with config.scheme.withHashtag; {
      background-color = "#e6" + config.scheme.base00;
      gpu-context = "wayland"; # fixes issues with transparency
      osd-back-color = base11;
      osd-border-color = base11;
      osd-color = base05;
      osd-font = config.fonts.sans.name;
      osd-shadow-color = base00;
      sub-font = config.fonts.sans.name;
      title = "\${filename} - mpv (nix)"; # allows niri to match window
    };

    enable = true;
    package = pkgs.mpv;
    bindings = { };

    scriptOpts = {
      uosc = {
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
      };
    };

    scripts =
      with pkgs.mpvScripts;
      [
        uosc
        mpv-subtitle-lines # requires uosc
        autosub
        youtube-upnext
        youtube-chat
      ]
      ++ lib.optionals isLinux [
        mpris
        mpv-notify-send
      ];
  };
}
