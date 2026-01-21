{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (mpv.override {
      scripts = with mpvScripts; [
        uosc
        sponsorblock
        mpris
      ];
    })
  ];
  home.file.".config/mpv/mpv.conf" = {
    text = with config.scheme; ''
      # Credit to https://github.com/catppuccin/mpv
      # Main mpv options
      background-color='#000000'
      osd-back-color='${config.scheme.withHashtag.base11}'
      osd-border-color='${config.scheme.withHashtag.base11}'
      osd-color='${config.scheme.withHashtag.base05}'
      osd-shadow-color='${config.scheme.withHashtag.base00}'

      # Stats script options
      # Options are on separate lines for clarity
      # Colors are in #BBGGRR format
      script-opts-append=stats-border_color=${base08}
      script-opts-append=stats-font_color=${base06}
      script-opts-append=stats-plot_bg_border_color=${base16}
      script-opts-append=stats-plot_bg_color=${base08}
      script-opts-append=stats-plot_color=${base16}

      # External script options
      # It is fine to leave these here even if one does not use these scripts because they are just ignored unless a script uses them

      # UOSC options
      script-opts-append=uosc-color=foreground=${base09},foreground_text=${base01},background=${base00},background_text=${base05},curtain=${base10},success=${base0B},error=${base08}
    '';
    force = true;
  };
}
