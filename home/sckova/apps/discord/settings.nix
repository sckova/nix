# home/sckova/apps/discord/settings.nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.file = {
    ".config/vesktop/settings.json" = {
      force = true;

      text = builtins.toJSON {
        arRPC = true;
        disableMinSize = true;
        discordBranch = "stable";
        minimizeToTray = true;

        spellCheckLanguages = [
          "en-US"
          "en"
        ];

        splashBackground = config.scheme.withHashtag.base00;
        splashColor = config.scheme.withHashtag.base05;
      };
    };

    ".config/vesktop/settings/settings.json" = {
      force = true;
      text = builtins.toJSON (import ./vencord.nix);
    };

    ".config/vesktop/state.json" = {
      force = true;

      text = builtins.toJSON {
        firstLaunch = false;

        windowBounds = {
          height = 1071;
          width = 853;
          x = 0;
          y = 0;
        };
      };
    };

    ".config/vesktop/themes/base16.css".source =
      let
        src = pkgs.fetchFromGitHub {
          hash = "sha256-aucLPmi4mkmIRMvaFrD9dNamYEQsox3hrTzwQZVUziE=";
          owner = "imbypass";
          repo = "base16-discord";
          rev = "c98a7a19371e085a441d257ced50e52e923d4160";
        };
      in
      pkgs.concatText "base16.css" [
        (src + "/base16.css")
        (src + "/base16.extras.css")
        (pkgs.writeText "discord-base16-vars.css" ''
          :root {
          ${lib.concatMapAttrsStringSep "\n" (name: value: "  --${name}: ${value};") (
            (lib.filterAttrs (
              name: _: builtins.match "base[0-9a-fA-F]{2}" name != null
            ) config.scheme.withHashtag)
            // {
              base00 = "color-mix(in srgb, ${config.scheme.withHashtag.base00} 40%, transparent)";
            }
          )}
            --font: "${config.fonts.sans.name}";
          }
        '')
      ];
  };
}
