{
  lib,
  pkgs,
  noctalia-shell,
  catppuccinFlavor ? "mocha",
  catppuccinAccent ? "mauve",
}:
let

  mkTheme = colors: {
    mPrimary = colors.${catppuccinAccent};
    mOnPrimary = colors.crust;
    mSecondary = colors.subtext0;
    mOnSecondary = colors.crust;
    mTertiary = colors.teal;
    mOnTertiary = colors.crust;
    mError = colors.red;
    mOnError = colors.crust;
    mSurface = colors.base;
    mOnSurface = colors.text;
    mSurfaceVariant = colors.surface0;
    mOnSurfaceVariant = colors.lavender;
    mOutline = colors.surface2;
    mShadow = colors.crust;
    mHover = colors.teal;
    mOnHover = colors.crust;
  };

  customScheme = {
    dark = mkTheme pkgs.catppuccin.${catppuccinFlavor};
    light = mkTheme pkgs.catppuccin.latte;
  };

  # Convert to JSON string for writing to file
  customSchemeJson = builtins.toJSON customScheme;
in
noctalia-shell.overrideAttrs (oldAttrs: {
  pname = "noctalia-shell-custom";
  nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.jq ];
  postPatch = (oldAttrs.postPatch or "") + ''
    # Create the Cat-Custom color scheme
    if [ -d Assets/ColorScheme/Catppuccin ]; then
      # Create Cat-Custom directory
      mkdir -p Assets/ColorScheme/Cat-Custom
      
      # Write the custom color scheme
      echo '${customSchemeJson}' | ${pkgs.jq}/bin/jq '.' > Assets/ColorScheme/Cat-Custom/Cat-Custom.json
      
      echo "Created Cat-Custom color scheme with ${catppuccinAccent} accent"
      echo "  Dark theme: ${catppuccinFlavor}"
      echo "  Light theme: latte"
    else
      echo "Warning: ColorScheme directory not found at expected path"
    fi

    # Add translations for Cat-Custom to all supported languages
    for lang in en fr de es pt zh-CN; do
      if [ -f "Assets/Translations/$lang.json" ]; then
        ${pkgs.jq}/bin/jq '.["color-scheme"].predefined.schemes["Cat-Custom"] = "Cat-Custom"' \
          "Assets/Translations/$lang.json" > "Assets/Translations/$lang.json.tmp"
        mv "Assets/Translations/$lang.json.tmp" "Assets/Translations/$lang.json"
        echo "Added Cat-Custom translation to $lang.json"
      fi
    done
  '';
  meta = oldAttrs.meta // {
    description = oldAttrs.meta.description + " (with Cat-Custom Catppuccin theme)";
  };
})
