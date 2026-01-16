{
  pkgs,
  noctalia-shell,
  catppuccin-flavor,
  catppuccin-accent,
}: let
  # Get the actual color palettes
  darkPalette = pkgs.catppuccin.${catppuccin-flavor};
  lightPalette = pkgs.catppuccin.latte;

  # Create theme from palette
  mkTheme = palette: accent: {
    mPrimary = palette.${accent};
    mOnPrimary = palette.crust;
    mSecondary = palette.subtext0;
    mOnSecondary = palette.crust;
    mTertiary = palette.teal;
    mOnTertiary = palette.crust;
    mError = palette.red;
    mOnError = palette.crust;
    mSurface = palette.mantle;
    mOnSurface = palette.text;
    mSurfaceVariant = palette.surface0;
    mOnSurfaceVariant = palette.lavender;
    mOutline = palette.surface2;
    mShadow = palette.crust;
    mHover = palette.subtext1;
    mOnHover = palette.crust;
  };

  # Build the complete color scheme
  customScheme = {
    dark = mkTheme darkPalette catppuccin-accent;
    light = mkTheme lightPalette catppuccin-accent;
  };

  # Convert to JSON
  schemeJson = builtins.toJSON customScheme;
in
  noctalia-shell.overrideAttrs (oldAttrs: {
    pname = "noctalia-shell-custom";
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.jq];

    postPatch =
      (oldAttrs.postPatch or "")
      + ''
        echo "Patching noctalia-shell with Cat-Custom theme..."
        echo "  Dark: ${catppuccin-flavor} / Light: latte"
        echo "  Accent: ${catppuccin-accent}"

        if [ -d Assets/ColorScheme/Catppuccin ]; then
          mkdir -p Assets/ColorScheme/Cat-Custom

          # Write the JSON directly
          cat > Assets/ColorScheme/Cat-Custom/Cat-Custom.json << 'COLORSCHEME_EOF'
        ${schemeJson}
        COLORSCHEME_EOF

          echo "Created Cat-Custom color scheme:"
          ${pkgs.jq}/bin/jq -C '.' Assets/ColorScheme/Cat-Custom/Cat-Custom.json || true

          # Add translation entries
          for lang in en fr de es pt zh-CN; do
            if [ -f "Assets/Translations/$lang.json" ]; then
              ${pkgs.jq}/bin/jq \
                '.["color-scheme"].predefined.schemes["Cat-Custom"] = "Cat-Custom"' \
                "Assets/Translations/$lang.json" > "Assets/Translations/$lang.json.tmp" \
                && mv "Assets/Translations/$lang.json.tmp" "Assets/Translations/$lang.json"
            fi
          done
        else
          echo "ERROR: ColorScheme directory not found"
          exit 1
        fi
      '';

    meta =
      oldAttrs.meta
      // {
        description = "${oldAttrs.meta.description} (Cat-Custom: ${catppuccin-flavor}/${catppuccin-accent})";
      };
  })
