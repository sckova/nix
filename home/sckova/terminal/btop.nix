# home/sckova/terminal/btop.nix
{
  config,
  lib,
  ...
}:
{
  programs.btop = {
    enable = true;
    settings.color_theme = "nixos";

    # Inspired by https://github.com/catppuccin/btop
    themes.nixos =
      with config.scheme.withHashtag;
      lib.generators.toKeyValue
        {
          mkKeyValue = k: v: /* ini */ "theme[${k}]=\"${v}\"";
        }
        {
          available_end = base08;
          available_mid = base12;
          available_start = base09;
          cached_end = base07;
          cached_mid = base0D;
          cached_start = base16;
          cpu_box = base0E;
          cpu_end = base07;
          cpu_mid = base16;
          cpu_start = base0C;
          div_line = base03;
          download_end = base08;
          download_mid = base12;
          download_start = base09;
          free_end = base0D;
          free_mid = base07;
          free_start = base0E;
          graph_text = base06;
          hi_fg = base0D;
          inactive_fg = base03;
          main_bg = "";
          main_fg = base05;
          mem_box = base0B;
          meter_bg = base02;
          net_box = base12;
          proc_box = base0D;
          proc_misc = base06;
          process_end = base0E;
          process_mid = base07;
          process_start = base16;
          selected_bg = base02;
          selected_fg = base0D;
          temp_end = base08;
          temp_mid = base0A;
          temp_start = base0B;
          title = base05;
          upload_end = base15;
          upload_mid = base0C;
          upload_start = base0B;
          used_end = base15;
          used_mid = base0C;
          used_start = base0B;
        };
  };
}
