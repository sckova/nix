{
  config,
  lib,
  pkgs,
  ...
}:
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
      package = pkgs.swaylock-effects;

      settings = {
        bs-hl-color = base09 + "E6"; # peach
        caps-lock-bs-hl-color = base09 + "E6"; # peach
        caps-lock-key-hl-color = base0E + "E6"; # mauve
        color = "000000"; # black
        effect-blur = "7x5";
        font-size = 24;
        image = "${config.home.homeDirectory}/.local/share/wallpaper/daily-colored.jpg";
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

      systemd.enable = true;

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
    niri-poweroff-display = {
      Install.WantedBy = [ "niri.service" ];

      Service = {
        ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "niri-poweroff-display";

            text = /* bash */ ''
              find '/run/user/1000/niri.wayland'*'.sock' | head -n 1
              niri msg action power-off-monitors
            '';
          }
        );

        Restart = "on-failure";
      };

      Unit = {
        After = [ "niri.service" ];
        Description = "Power off displays at login";
        PartOf = [ "niri.service" ];
        Type = "oneshot";
      };
    };

    swaylock = {
      Install.WantedBy = [ "niri.service" ];

      Service = {
        ExecStart = lib.getExe config.programs.swaylock.package;
        Restart = "on-failure";
      };

      Unit = {
        After = [ "niri.service" ];
        Description = "Screen locker";
        Documentation = "https://github.com/swaywm/swaylock";
        PartOf = [ "niri.service" ];
        X-Restart-Triggers = [ config.programs.swaylock.settings.image ];
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
