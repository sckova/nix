{ pkgs, config, ... }:
{
  imports = [
    ./niri.nix
    ./noctalia.nix
    ./wallpaper.nix
  ];

  home.packages = with pkgs; [
    xdg-desktop-portal
    xwayland-satellite
  ];

  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    settings = {
      pop_to_root_on_close = true;
      font.normal = {
        family = config.userOptions.fontSans.name;
        size = 11;
      };
      launcher_window = {
        opacity = 0.9;
        client_side_decorations.enabled = true;
      };
      clipboard.preferences = {
        encryption = true;
        eraseOnStartup = true;
        ignorePasswords = true;
        monitoring = true;
      };
      keybinds = {
        open-settings = "ctrl+super+S";
      };
      favorites = [
        "applications:firefox"
        "@Ninetonine/searxng:search-with-searxng"
        "clipboard:history"
      ];
      theme.dark = {
        name = "nixos";
        icon_theme = config.gtk.iconTheme.name;
      };
      providers = {
        "@mattisssa/spotify-player" = {
          entrypoints = {
            addPlayingSongToPlaylist.enabled = true;
            copyArtistAndTitle.enabled = true;
            toggleShuffle.enabled = true;
            queue.enabled = true;
          };
        };
        "@Ninetonine/searxng" = {
          preferences = {
            instance_domain = "http://localhost:5364";
            default_category = "general";
            engines = "";
            keep_previous_search = false;
            languages = "";
          };
          entrypoints.search-with-searxng.alias = "@s";
        };
        "@samlinville/tailscale".preferences = {
          tailscalePath = "/run/current-system/sw/bin/tailscale";
        };
      };
    };
    extensions =
      let
        raycast.rev = "4237b41dfaf3903de0f18b1d7fefb26290d92829";
        vicinae =
          pkgs.fetchFromGitHub {
            owner = "vicinaehq";
            repo = "extensions";
            rev = "89cc49471c3e7119bfd36d68998cefe534bddab8";
            sha256 = "sha256-LfqeVlMwclHJKsJu5jJoztjlaCeIasQsiv3P9+eKDNw=";
          }
          + "/extensions/";
      in
      [
        (config.lib.vicinae.mkRayCastExtension {
          name = "spotify-player";
          sha256 = "sha256-332DOAKVOnXkL/tLpQXlSPYl2fveAX46e9vfC7RoyVA=";
          rev = raycast.rev;
        })
        (config.lib.vicinae.mkRayCastExtension {
          name = "tailscale";
          sha256 = "sha256-fPRHDTazFfUDvsbvbl0JyZkKSA1i/rIhMWVG+9CAfpY=";
          rev = raycast.rev;
        })
        (config.lib.vicinae.mkExtension {
          name = "github";
          src = vicinae + "github";
        })
        (config.lib.vicinae.mkExtension {
          name = "nix";
          src = vicinae + "nix";
        })
        (config.lib.vicinae.mkExtension {
          name = "niri";
          src = vicinae + "niri";
        })
        (config.lib.vicinae.mkExtension {
          name = "searxng";
          src = vicinae + "searxng";
        })
        (config.lib.vicinae.mkExtension {
          name = "wikipedia";
          src = vicinae + "wikipedia";
        })
      ];
    themes.nixos = {
      meta = {
        version = 1;
        name = "NixOS";
        description = "Generated based on your color scheme";
        variant = "dark";
        icon = "icons/catppuccin-mocha.png";
        inherits = "vicinae-dark";
      };
      colors = with config.scheme.withHashtag; {
        core = {
          background = base00;
          foreground = base05;
          secondary_background = base10;
          border = base02;
          accent = config.colors.accent;
        };
        accents = {
          blue = base0D;
          green = base0B;
          magenta = base17;
          orange = base09;
          purple = base0E;
          red = base08;
          yellow = base0A;
          cyan = base0C;
        };
      };
    };
  };

  programs.swaylock = with config.scheme; {
    enable = true;
    # package = pkgs.swaylock-effects;
    settings = {
      # this would sometimes load the previous day's wallpaper
      # when it is run before the bing retrieval script finishes
      # image = "~/.local/share/wallpaper/daily-colored.jpg";
      # effect-blur = "7x5";
      color = "000000"; # black
      font-size = 24;
      indicator-idle-visible = true;
      indicator-radius = 100;
      show-failed-attempts = true;

      bs-hl-color = base09 + "E6"; # peach
      caps-lock-bs-hl-color = base09 + "E6"; # peach
      caps-lock-key-hl-color = base0E + "E6"; # mauve
      inside-color = base00 + "E6"; # base
      inside-clear-color = base00 + "E6"; # base
      inside-caps-lock-color = base00 + "E6"; # base
      inside-ver-color = base00 + "E6"; # base
      inside-wrong-color = base00 + "E6"; # base
      key-hl-color = base0D + "E6"; # blue
      layout-bg-color = base00 + "E6"; # base
      layout-border-color = base00 + "E6"; # base
      layout-text-color = base05 + "E6"; # text
      line-color = base00 + "E6"; # base
      line-clear-color = base00 + "E6"; # base
      line-caps-lock-color = base00 + "E6"; # base
      line-ver-color = base00 + "E6"; # base
      line-wrong-color = base00 + "E6"; # base
      ring-color = base00 + "E6"; # base
      ring-clear-color = base09 + "E6"; # peach
      ring-caps-lock-color = base00 + "E6"; # base
      ring-ver-color = base0B + "E6"; # green
      ring-wrong-color = base00 + "E6"; # base
      separator-color = "00000000"; # transparent
      text-color = base05 + "E6"; # text
      text-clear-color = base09 + "E6"; # peach
      text-caps-lock-color = base0E + "E6"; # mauve
      text-ver-color = base05 + "E6"; # text
      text-wrong-color = base08 + "E6"; # red
    };
  };

  systemd.user.services.swaylock = {
    Unit = {
      After = [ "niri.service" ];
      PartOf = [ "niri.service" ];
      Description = "Screen locker";
      Documentation = "https://github.com/swaywm/swaylock";
    };

    Service = {
      ExecStart = "${config.programs.swaylock.package}/bin/swaylock";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "niri.service" ];
  };

  systemd.user.services.vicinae = {
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

  xsession = {
    enable = true;
    windowManager.command = "niri";
  };
}
