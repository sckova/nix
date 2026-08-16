{ config, ... }: {
  programs.noctalia.customPalettes.nixos =
    with config.scheme.withHashtag;
    let
      scheme = {
        mError = base12;
        mHover = base04;
        mOnError = base00;
        mOnHover = base00;
        mOnPrimary = base00;
        mOnSecondary = base00;
        mOnSurface = base05;
        mOnSurfaceVariant = base05;
        mOnTertiary = base00;
        mOutline = base02;
        mPrimary = config.scheme.withHashtag.${config.colors.accent};
        mSecondary = base13;
        mShadow = base00;
        mSurface = base10;
        mSurfaceVariant = base01;
        mTertiary = base04;

        terminal = {
          background = base00;

          bright = {
            black = base02;
            blue = base0D;
            cyan = base0C;
            green = base0B;
            magenta = base17;
            red = base08;
            white = base04;
            yellow = base0A;
          };

          cursor = base05;
          cursorText = base00;
          foreground = base05;

          normal = {
            black = base02;
            blue = base0D;
            cyan = base0C;
            green = base0B;
            magenta = base17;
            red = base08;
            white = base04;
            yellow = base0A;
          };

          selectionBg = base02;
          selectionFg = base05;
        };
      };
    in
    {
      dark = scheme;
      light = scheme;
    };
}
