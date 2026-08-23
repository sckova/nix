# home/sckova/tiling/vicinae.nix
{
  config,
  pkgs,
  ...
}:
{
  programs.vicinae = {
    enable = true;

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
          rev = raycast.rev;
          sha256 = "sha256-332DOAKVOnXkL/tLpQXlSPYl2fveAX46e9vfC7RoyVA=";
        })
        (config.lib.vicinae.mkRayCastExtension {
          name = "tailscale";
          rev = raycast.rev;
          sha256 = "sha256-fPRHDTazFfUDvsbvbl0JyZkKSA1i/rIhMWVG+9CAfpY=";
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

    settings = {
      clipboard.preferences = {
        encryption = true;
        eraseOnStartup = true;
        ignorePasswords = true;
        monitoring = true;
      };

      favorites = [
        "applications:firefox"
        "@Ninetonine/searxng:search-with-searxng"
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
        "@Ninetonine/searxng" = {
          entrypoints.search-with-searxng.alias = "@s";

          preferences = {
            default_category = "general";
            engines = "";
            instance_domain = "http://localhost:5364";
            keep_previous_search = false;
            languages = "";
          };
        };

        "@mattisssa/spotify-player".entrypoints = {
          addPlayingSongToPlaylist.enabled = true;
          copyArtistAndTitle.enabled = true;
          queue.enabled = true;
          toggleShuffle.enabled = true;
        };

        "@samlinville/tailscale".preferences.tailscalePath = "/run/current-system/sw/bin/tailscale";
        files.preferences.autoIndexing = false;
      };

      theme.dark = {
        icon_theme = config.gtk.iconTheme.name;
        name = "nixos";
      };
    };

    systemd.enable = false;

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
}
