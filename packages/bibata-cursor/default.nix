# packages/bibata-cursor/default.nix
{
  lib,
  fetchFromGitHub,
  fetchurl,
  openjdk25,
  stdenv,
  base00 ? "#1e1e2e",
  base01 ? "#313244",
  base02 ? "#45475a",
  base03 ? "#6c7086",
  base04 ? "#a6adc8",
  base05 ? "#cdd6f4",
  base06 ? "#f5e0dc",
  base07 ? "#b4befe",
  base08 ? "#f38ba8",
  base09 ? "#fab387",
  base0A ? "#f9e2af",
  base0B ? "#a6e3a1",
  base0C ? "#94e2d5",
  base0D ? "#89b4fa",
  base0E ? "#cba6f7",
  base0F ? "#f2cdcd",
  base10 ? "#181825",
  base11 ? "#11111b",
  base12 ? "#eba0ac",
  base13 ? "#f5e0dc",
  base14 ? "#a6e3a1",
  base15 ? "#89dceb",
  base16 ? "#74c7ec",
  base17 ? "#f5c2e7",
  baseColor ? "#FF0000",
  cursorSizes ? "24",
  outlineColor ? "#0000FF",
  # --pointer-shadow[=<blur>[,<dx>[,<dy>[,<opacity>[,#<color>]]]]]
  pointerShadow ? "6,18,9,0.3,${outlineColor}",
  strokeWidth ? "12",
  themeName ? "catppuccin-mocha",
}:

let
  mousegen = fetchurl {
    hash = "sha256-SRDSIDCwh6g3DjaFLjBEplUOrDMgACucvQltNULBlH4=";
    url = "https://github.com/stanio/stanio-misc/releases/download/mousegen-0.11.7/mousegen.sh";
  };
  src = fetchFromGitHub {
    hash = "sha256-TqguzNPH2GRHHyAifIb953YrVpjZe5eEP2r/Kd1qV8s=";
    owner = "stanio";
    repo = "Bibata_Cursor";
    rev = "v${version}";
  };
  version = "2.0.7-stanio-16";
in
stdenv.mkDerivation {
  inherit version src;

  buildPhase = /* bash */ ''
    runHook preBuild

    echo "Set up the color scheme"
    cat <<'EOF' > ./configs/colors.jsonc
    ${builtins.toJSON {
      /*
        editor's note:
        this is loosely based off the upstream CatMocha theme
        (which the comments correspond to)
        exact color matching turned out to be incorrect so i made adjustments,
        which are described in the parentheses. TODO: finish recoloring bibata
      */
      "Nix" = {
        "#0000F7FF" = base15; # sky
        "#0000F8FF" = base16; # sapphire
        "#0000F9FF" = base0D; # blue
        "#0000FAFF" = base0E; # mauve
        "#0000FBFF" = base0B; # green
        "#0000FCFF" = base07; # lavender
        "#0000FDFF" = base09; # peach
        "#0000FE" = base0D; # red (actual: blue)
        "#0000FEFF" = base0D; # red (actual: blue)
        "#0000FF" = outlineColor; # subtext1 (actual: text)
        "#00FF00" = baseColor; # base
        "#0101FF" = base00; # base
        "#01FF01" = base05; # subtext1 (actual: text)
        "#06B231" = base11; # green/copy
        "#0A6857" = base11; # dark green/location
        "#179DD8" = base15; # sky/move
        "#2C2C2C" = base01; # dark gray/person
        "#32A0DA" = base15; # sky
        "#4FADDF" = base15; # base (top-left -> sky)
        "#5F3BE4" = base0E; # violet/ctx-menu
        "#606060" = base02; # gray/link
        "#7EBA41" = base0B; # green
        "#96C865" = base0B; # base (bottom-left -> green)
        "#F05024" = base12; # maroon
        "#F1613A" = base09; # base (top-right -> peach)
        "#F27400" = base11; # orange/ask
        "#FCB813" = base0A; # yellow
        "#FDBE2A" = base0A; # base (bottom-right -> yellow)
        "#FE0000" = base00; # red/forbidden (base used in some backgrounds)
        "#FF0000" = base00; # base (wait background)
        "#FFFFF7" = base15; # sky
        "#FFFFF8" = base16; # sapphire
        "#FFFFF9" = base0D; # blue
        "#FFFFFA" = base0E; # mauve
        "#FFFFFB" = base0B; # green
        "#FFFFFC" = base07; # lavender
        "#FFFFFD" = base09; # peach
        "#FFFFFE" = base08; # red
        "black" = base00; # base
        "white" = base05; # subtext1 (actual: text)
      };
    }}
    EOF

    cp ${mousegen} bin/mousegen
    chmod +x bin/mousegen
    export PATH="$PWD/bin:$PATH"

    echo "Render the colorized cursors"
    mousegen-render \
      --linux-cursors \
      --color Nix \
      -r ${cursorSizes} \
      --pointer-shadow=${pointerShadow} \
      --stroke-width=${strokeWidth}

    echo "Create standard X11 cursor-name aliases"
    mousegen x11Symlinks -c configs themes

    runHook postBuild
  '';

  installPhase = /* bash */ ''
    runHook preInstall
    install -dm 0755 $out/share/icons
    # editor's note: i do not care for this theme name system
    # for some reason it just tacks on every optional value you have??
    cp -r themes/Bibata-Modern\*-Nix-S${strokeWidth}-Shadow/ $out/share/icons/${themeName}
    runHook postInstall
  '';

  nativeBuildInputs = [ openjdk25 ];
  pname = "bibata-${themeName}-cursor";

  meta = with lib; {
    description = "Custom colored Bibata Cursor theme built from source";
    homepage = "https://github.com/ful1e5/Bibata_Cursor";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
