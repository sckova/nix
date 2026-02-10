{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.mpv = {
    enable = true;
    package = pkgs.mpv;
    bindings = { };
    config = with config.scheme.withHashtag; {
      background-color = "#000000";
      osd-back-color = base11;
      osd-border-color = base11;
      osd-color = base05;
      osd-shadow-color = base00;
      sub-font = config.userOptions.fontSans.name;
      osd-font = config.userOptions.fontSans.name;
    };
    scripts = with pkgs.mpvScripts; [
      uosc
      mpv-subtitle-lines # requires uosc
      mpris
      autosub
      youtube-upnext
      youtube-chat
      mpv-notify-send
    ];
    scriptOpts = {
      uosc = {
        color =
          with config.scheme;
          lib.concatStringsSep "," (
            lib.mapAttrsToList (key: value: "${key}=${value}") {
              foreground = config.scheme.${config.colors.accent};
              foreground_text = base01;
              background = base00;
              background_text = base05;
              curtain = base10;
              success = base0B;
              error = base08;
            }
          );
      };
    };
  };
}
