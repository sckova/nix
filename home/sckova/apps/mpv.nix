{
  config,
  pkgs,
  lib,
  isLinux,
  ...
}:
{
  programs.mpv = {
    enable = true;
    package = pkgs.mpv;
    bindings = { };
    config = with config.scheme.withHashtag; {
      gpu-context = "wayland"; # fixes issues with transparency
      title = "\${filename} - mpv (nix)"; # allows niri to match window
      background-color = "#e6" + config.scheme.base00;
      osd-back-color = base11;
      osd-border-color = base11;
      osd-color = base05;
      osd-shadow-color = base00;
      sub-font = config.fontSans.name;
      osd-font = config.fontSans.name;
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
