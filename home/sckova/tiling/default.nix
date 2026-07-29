{ config, pkgs, ... }:
{
  imports = [
    ./niri.nix
    ./noctalia.nix
    ./wallpaper.nix
    ./wluma.nix
  ];

  home.packages = with pkgs; [
    xdg-desktop-portal
    xwayland-satellite
  ];

  programs = {
    swaylock = with config.scheme; {
      enable = true;

      # package = pkgs.swaylock-effects;
      settings = {
        bs-hl-color = base09 + "E6"; # peach
        caps-lock-bs-hl-color = base09 + "E6"; # peach
        caps-lock-key-hl-color = base0E + "E6"; # mauve
        # this would sometimes load the previous day's wallpaper
        # when it is run before the bing retrieval script finishes
        # image = "~/.local/share/wallpaper/daily-colored.jpg";
        # effect-blur = "7x5";
        color = "000000"; # black
        font-size = 24;
        indicator-idle-visible = true;
        indicator-radius = 100;
        inside-caps-lock-color = base00 + "E6"; # base
        inside-clear-color = base00 + "E6"; # base
        inside-color = base00 + "E6"; # base
        inside-ver-color = base00 + "E6"; # base
        inside-wrong-color = base00 + "E6"; # base
        key-hl-color = base0D + "E6"; # blue
        layout-bg-color = base00 + "E6"; # base
        layout-border-color = base00 + "E6"; # base
        layout-text-color = base05 + "E6"; # text
        line-caps-lock-color = base00 + "E6"; # base
        line-clear-color = base00 + "E6"; # base
        line-color = base00 + "E6"; # base
        line-ver-color = base00 + "E6"; # base
        line-wrong-color = base00 + "E6"; # base
        ring-caps-lock-color = base00 + "E6"; # base
        ring-clear-color = base09 + "E6"; # peach
        ring-color = base00 + "E6"; # base
        ring-ver-color = base0B + "E6"; # green
        ring-wrong-color = base00 + "E6"; # base
        separator-color = "00000000"; # transparent
        show-failed-attempts = true;
        text-caps-lock-color = base0E + "E6"; # mauve
        text-clear-color = base09 + "E6"; # peach
        text-color = base05 + "E6"; # text
        text-ver-color = base05 + "E6"; # text
        text-wrong-color = base08 + "E6"; # red
      };
    };

    vicinae = {
      enable = true;

      settings = {
        clipboard.preferences = {
          encryption = true;
          eraseOnStartup = true;
          ignorePasswords = true;
          monitoring = true;
        };

        favorites = [
          "applications:firefox"
          # "@Ninetonine/searxng:search-with-searxng"
          "clipboard:history"
        ];

        font.normal = {
          family = config.fonts.sans.name;
          size = 11;
        };

        keybinds.open-settings = "ctrl+super+S";

        launcher_window = {
          client_side_decorations.enabled = true;
          opacity = 0.9;
        };

        pop_to_root_on_close = true;

        providers = {
          files.preferences.autoIndexing = false;
          #   "@mattisssa/spotify-player" = {
          #     entrypoints = {
          #       addPlayingSongToPlaylist.enabled = true;
          #       copyArtistAndTitle.enabled = true;
          #       toggleShuffle.enabled = true;
          #       queue.enabled = true;
          #     };
          #   };
          #   "@Ninetonine/searxng" = {
          #     preferences = {
          #       instance_domain = "http://localhost:5364";
          #       default_category = "general";
          #       engines = "";
          #       keep_previous_search = false;
          #       languages = "";
          #     };
          #     entrypoints.search-with-searxng.alias = "@s";
          #   };
          #   "@samlinville/tailscale".preferences = {
          #     tailscalePath = "/run/current-system/sw/bin/tailscale";
          #   };
        };

        theme.dark = {
          icon_theme = config.gtk.iconTheme.name;
          name = "nixos";
        };
      };

      systemd.enable = true;

      # extensions =
      #   let
      #     raycast.rev = "4237b41dfaf3903de0f18b1d7fefb26290d92829";
      #     vicinae =
      #       pkgs.fetchFromGitHub {
      #         owner = "vicinaehq";
      #         repo = "extensions";
      #         rev = "89cc49471c3e7119bfd36d68998cefe534bddab8";
      #         sha256 = "sha256-LfqeVlMwclHJKsJu5jJoztjlaCeIasQsiv3P9+eKDNw=";
      #       }
      #       + "/extensions/";
      #   in
      #   [
      #     (config.lib.vicinae.mkRayCastExtension {
      #       name = "spotify-player";
      #       sha256 = "sha256-332DOAKVOnXkL/tLpQXlSPYl2fveAX46e9vfC7RoyVA=";
      #       rev = raycast.rev;
      #     })
      #     (config.lib.vicinae.mkRayCastExtension {
      #       name = "tailscale";
      #       sha256 = "sha256-fPRHDTazFfUDvsbvbl0JyZkKSA1i/rIhMWVG+9CAfpY=";
      #       rev = raycast.rev;
      #     })
      #     (config.lib.vicinae.mkExtension {
      #       name = "github";
      #       src = vicinae + "github";
      #     })
      #     (config.lib.vicinae.mkExtension {
      #       name = "nix";
      #       src = vicinae + "nix";
      #     })
      #     (config.lib.vicinae.mkExtension {
      #       name = "niri";
      #       src = vicinae + "niri";
      #     })
      #     (config.lib.vicinae.mkExtension {
      #       name = "searxng";
      #       src = vicinae + "searxng";
      #     })
      #     (config.lib.vicinae.mkExtension {
      #       name = "wikipedia";
      #       src = vicinae + "wikipedia";
      #     })
      #   ];
      themes.nixos = {
        colors = with config.scheme.withHashtag; {
          accents = {
            blue = base0D;
            cyan = base0C;
            green = base0B;
            magenta = base17;
            orange = base09;
            purple = base0E;
            red = base08;
            yellow = base0A;
          };

          core = {
            accent = config.colors.accent;
            background = base00;
            border = base02;
            foreground = base05;
            secondary_background = base10;
          };
        };

        meta = {
          description = "Generated based on your color scheme";
          icon = "icons/catppuccin-mocha.png";
          inherits = "vicinae-dark";
          name = "NixOS";
          variant = "dark";
          version = 1;
        };
      };
    };
  };

  services.tailscale-systray = {
    enable = true;
    theme = "dark:nobg";
  };

  systemd.user.services = {
    swaylock = {
      Install.WantedBy = [ "niri.service" ];

      Service = {
        ExecStart = "${config.programs.swaylock.package}/bin/swaylock";
        Restart = "on-failure";
      };

      Unit = {
        After = [ "niri.service" ];
        Description = "Screen locker";
        Documentation = "https://github.com/swaywm/swaylock";
        PartOf = [ "niri.service" ];
      };
    };

    vicinae = {
      Install.WantedBy = [ "niri.service" ];

      Service = {
        ExecStart = "${pkgs.vicinae}/bin/vicinae server";
        KillMode = "process";
        Restart = "always";
        RestartSec = 5;
        Type = "simple";
      };

      Unit = {
        After = [ "niri.service" ];
        Description = "Vicinae server daemon";
        Documentation = "https://docs.vicinae.com";
      };
    };
  };

  xsession = {
    enable = true;
    windowManager.command = "niri";
  };
}
