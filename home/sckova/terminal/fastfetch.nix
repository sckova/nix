# home/sckova/terminal/fastfetch.nix
# credit to harilvfs:
# https://github.com/harilvfs/fastfetch
{
  pkgs,
  ...
}:
{
  programs.fastfetch = {
    enable = true;

    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      display.separator = " ";

      logo = {
        height = 36;
        padding.top = 2;
        source = pkgs.nixos-icons + "/share/icons/hicolor/512x512/apps/nix-snowflake.png";
        type = "kitty-direct";
      };

      modules = [
        "break"
        {
          keyWidth = 10;
          type = "title";
        }
        "break"
        {
          key = " ";
          keyColor = "34";
          type = "os";
        }
        {
          key = " ";
          keyColor = "34";
          type = "kernel";
        }
        {
          key = " ";
          keyColor = "34";
          type = "packages";
        }
        {
          key = " ";
          keyColor = "34";
          type = "shell";
        }
        {
          key = " ";
          keyColor = "34";
          type = "terminal";
        }
        {
          key = " ";
          keyColor = "34";
          type = "wm";
        }
        {
          key = " ";
          keyColor = "34";
          type = "display";
        }
        {
          format = "{1}";
          key = " ";
          keyColor = "34";
          type = "cpu";
        }
        {
          format = "{2}";
          key = " ";
          keyColor = "34";
          type = "gpu";
        }
        {
          format = "{3}";
          key = " ";
          keyColor = "34";
          type = "gpu";
        }
        {
          key = "󰍛 ";
          keyColor = "34";
          type = "memory";
        }
        {
          key = "󰾴 ";
          keyColor = "34";
          type = "swap";
        }
        {
          key = " ";
          keyColor = "34";
          type = "disk";
        }
        {
          key = " ";
          keyColor = "34";
          type = "uptime";
        }
        {
          key = "󱦟 ";
          keyColor = "34";
          text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
          type = "command";
        }
        "break"
        {
          format =
            let
              esc = builtins.fromJSON "\"\\u001b\"";
            in
            "${esc}[90m  ${esc}[31m  ${esc}[32m  ${esc}[33m  ${esc}[34m  ${esc}[35m  ${esc}[36m  ${esc}[37m${esc}[0m";

          type = "custom";
        }
        "break"
        "break"
      ];
    };
  };
}
