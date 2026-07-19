# credit to harilvfs:
# https://github.com/harilvfs/fastfetch/tree/old-days
{
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        height = 15;

        padding = {
          left = 3;
          top = 5;
        };

        type = "builtin";
      };

      modules = [
        "break"
        {
          format = "{#90}┌──────────────────────Hardware──────────────────────┐";
          type = "custom";
        }
        {
          key = "󰌢  PC";
          keyColor = "green";
          type = "host";
        }
        {
          key = "│ ├󰻠 ";
          keyColor = "green";
          type = "cpu";
        }
        {
          key = "│ ├󰍹 ";
          keyColor = "green";
          type = "gpu";
        }
        {
          key = "│ ├󰑭 ";
          keyColor = "green";
          type = "memory";
        }
        {
          key = "└ └󰋊 ";
          keyColor = "green";
          type = "disk";
        }
        {
          format = "{#90}└────────────────────────────────────────────────────┘";
          type = "custom";
        }
        "break"
        {
          format = "{#90}┌──────────────────────Software──────────────────────┐";
          type = "custom";
        }
        {
          key = "  OS";
          keyColor = "yellow";
          type = "os";
        }
        {
          key = "│ ├󰌽 ";
          keyColor = "yellow";
          type = "kernel";
        }
        {
          key = "│ ├󰖡 ";
          keyColor = "yellow";
          type = "bios";
        }
        {
          key = "│ ├󰏗 ";
          keyColor = "yellow";
          type = "packages";
        }
        {
          key = "└ └󰞷 ";
          keyColor = "yellow";
          type = "shell";
        }
        "break"
        {
          key = "󰧨  DE";
          keyColor = "blue";
          type = "de";
        }
        {
          key = "│ ├󰍁 ";
          keyColor = "blue";
          type = "lm";
        }
        {
          key = "│ ├󱂬 ";
          keyColor = "blue";
          type = "wm";
        }
        {
          key = "│ ├󰉦 ";
          keyColor = "blue";
          type = "wmtheme";
        }
        {
          key = "└ └󰆍 ";
          keyColor = "blue";
          type = "terminal";
        }
        {
          format = "{#90}└────────────────────────────────────────────────────┘";
          type = "custom";
        }
        "break"
        {
          format = "{#90}┌────────────────────Uptime / Age / DT────────────────────┐";
          type = "custom";
        }
        {
          key = "  ›  OS Age  ";
          keyColor = "magenta";
          text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
          type = "command";
        }
        {
          key = "  ›  Uptime  ";
          keyColor = "magenta";
          type = "uptime";
        }
        {
          key = "  ›  DateTime  ";
          keyColor = "magenta";
          type = "datetime";
        }
        {
          format = "{#90}└─────────────────────────────────────────────────────────┘";
          type = "custom";
        }
        {
          paddingLeft = 2;
          symbol = "circle";
          type = "colors";
        }
      ];
    };
  };
}
