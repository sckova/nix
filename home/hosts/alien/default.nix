{
  config,
  pkgs,
  lib,
  pkgs-unstable,
  spicetify-nix,
  ...
}:
{
  colors = {
    scheme = "catppuccin-mocha";
    accent = "base0D";
  };

  home.packages = with pkgs; [
    pkgs-unstable.ckan

    # steam gtk theming
    adwsteamgtk
    daggerfall-unity
    vintagestory
    gamemode
  ];

  programs.noctalia-shell.settings.brightness.enableDdcSupport = true;
  programs.noctalia-shell.settings.bar = {
    position = "top";
    density = "default";
  };

  programs.spicetify =
    let
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        ncsVisualizer
      ];
      enabledSnippets = with spicePkgs.snippets; [
        rotatingCoverart
        pointer
      ];

      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
}
