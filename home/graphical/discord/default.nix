{
  config,
  pkgs,
  ...
}: let
  catppuccin-discord-src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "discord";
    rev = "1b2dffbabf75a294a0fb9245f9f7244a853e7ada";
    hash = "sha256-LdUPnnbbSwgaw37FJD2s1vPiTaISaYbtOWRxQIekQkQ=";
  };

  yarnOfflineCache = pkgs.fetchYarnDeps {
    yarnLock = "${catppuccin-discord-src}/yarn.lock";
    hash = "sha256-BhE3aKyA/LBErjWx+lbEVb/CIXhqHkXbV+9U2djIBhs=";
  };

  catppuccin-discord-pkg = pkgs.stdenv.mkDerivation {
    pname = "catppuccin-discord";
    version = "unstable";

    src = catppuccin-discord-src;

    nativeBuildInputs = with pkgs; [
      yarn
      nodejs
      fixup-yarn-lock
      nodePackages.sass
    ];

    postPatch = ''
      substituteInPlace package.json \
        --replace-fail "--no-charset --no-source-map" ""
    '';

    configurePhase = ''
      export HOME=$TMPDIR
      yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
      fixup-yarn-lock yarn.lock
      yarn install --offline --frozen-lockfile --ignore-scripts --ignore-platform
    '';

    buildPhase = ''
      yarn --offline build
      yarn --offline release
    '';

    installPhase = ''
      mkdir -p $out
      find .
      cp -r dist/* $out
    '';
  };

  catppuccin-discord = "${catppuccin-discord-pkg}/dist/catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}.theme.css";

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
