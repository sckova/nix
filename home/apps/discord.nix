{
  config,
  pkgs,
  ...
}:
let
  catppuccin-discord = "${pkgs.catppuccin-discord}/share/catppuccin-discord/catppuccin-mocha-*.theme.css";

  mergedThemes = pkgs.runCommand "mergedConfig" { } ''
    mkdir -p $out
    cp -rvf ${pkgs.base16-discord-git}/base16.css $out/base16.css
    cp -rvf ${catppuccin-discord} $out
  '';

  vesktopSettings = {
    discordBranch = "stable";
    minimizeToTray = true;
    arRPC = true;
    splashColor = config.scheme.withHashtag.base05;
    splashBackground = config.scheme.withHashtag.base00;
    spellCheckLanguages = [
      "en-US"
      "en"
    ];
    disableMinSize = true;
  };

  stateConfig = {
    firstLaunch = false;
    windowBounds = {
      x = 0;
      y = 0;
      width = 853;
      height = 1071;
    };
  };
in
{
  home.packages = with pkgs; [ vesktop ];

  home.file.".config/vesktop/settings.json" = {
    text = builtins.toJSON vesktopSettings;
    force = true;
  };

  home.file.".config/vesktop/settings/settings.json" = {
    text = builtins.toJSON (import ./vencord.nix);
    force = true;
  };

  home.file.".config/vesktop/settings/quickCss.css" = with config.scheme.withHashtag; {
    text = ''
      * {
        font-family: "${config.userOptions.fontSans.name}" !important;
        font-size: ${toString config.userOptions.fontSans.size}px;
      }

      :root {
        --base00: ${base00};
        --base01: ${base01};
        --base02: ${base02};
        --base03: ${base03};
        --base04: ${base04};
        --base05: ${base05};
        --base06: ${base06};
        --base07: ${base07};
        --base08: ${base08};
        --base09: ${base09};
        --base0A: ${base0A};
        --base0B: ${base0B};
        --base0C: ${base0C};
        --base0D: ${base0D};
        --base0E: ${base0E};
        --base0F: ${base0F};
      }
    '';
    force = true;
  };

  home.file.".config/vesktop/state.json" = {
    text = builtins.toJSON stateConfig;
    force = true;
  };

  home.file.".config/vesktop/themes" = {
    source = mergedThemes;
    recursive = true;
    force = true;
  };
}
