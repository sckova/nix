{
  config,
  pkgs,
  ...
}: let
  catppuccin-discord = "${pkgs.catppuccin-discord}/share/catppuccin-discord/catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}.theme.css";

  mergedThemes = pkgs.runCommand "mergedConfig" {} ''
    mkdir -p $out
    cp ${catppuccin-discord} $out/catppuccin.css
  '';

  vesktopSettings = {
    discordBranch = "stable";
    minimizeToTray = true;
    arRPC = true;
    splashColor = "${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.text}";
    splashBackground = "${pkgs.catppuccin.rgb.${config.catppuccin.flavor}.base}";
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
in {
  home.packages = with pkgs; [vesktop];

  home.file.".config/vesktop/settings.json" = {
    text = builtins.toJSON vesktopSettings;
    force = true;
  };

  home.file.".config/vesktop/settings/settings.json" = {
    text = builtins.toJSON (import ./vencord.nix);
    force = true;
  };

  home.file.".config/vesktop/settings/quickCss.css" = {
    text = ''
      * {
        font-family: "${config.userOptions.fontSans.name}" !important;
        font-size: ${toString config.userOptions.fontSans.size}px;
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
