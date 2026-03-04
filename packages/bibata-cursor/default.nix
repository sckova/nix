{
  pkgs ? import <nixpkgs> { },
  themeName ? "bibata",
  baseColor ? "#000000",
  outlineColor ? "#FFFFFF",
  watchBackgroundColor ? "",
  cursorSizes ? "24",
}:

let
  version = "2.0.7";

  src = pkgs.fetchFromGitHub {
    owner = "ful1e5";
    repo = "Bibata_Cursor";
    rev = "v${version}";
    hash = "sha256-kIKidw1vditpuxO1gVuZeUPdWBzkiksO/q2R/+DUdEc=";
  };

  yarnOfflineCache = pkgs.fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-EpWIGoFFokmzRML2r/dCM+TImOCtii8mifLgnLKdUMY=";
  };

in
pkgs.stdenv.mkDerivation {
  pname = "bibata-${themeName}-cursor";
  inherit version src;

  nativeBuildInputs = with pkgs; [
    yarn
    nodejs
    fixup-yarn-lock
    python3Packages.clickgen
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    # Required to satisfy dynamic linking for prebuilt JS native modules (like resvg-js)
    stdenv.cc.cc.lib
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)

    echo "1. Setup offline yarn cache"
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
    fixup-yarn-lock yarn.lock

    echo "2. Install node_modules offline"
    yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    rm -rf node_modules/@resvg/resvg-js-linux-*-musl

    echo "3. Patch prebuilt node binaries (like resvg) so they can run in the Nix sandbox"
    autoPatchelf node_modules/

    # https://github.com/ful1e5/cbmp/issues/4
    echo "4. Patch 'ora' library to prevent Nix sandbox hangs"
    sed -i 's/this.#isEnabled = .*/this.#isEnabled = false;/g' node_modules/ora/index.js

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    echo "Splitting SVGs to render across $NIX_BUILD_CORES cores..."

    echo "1. Distribute SVGs evenly into chunk directories"
    if [ -n "${watchBackgroundColor}" ]; then
      ./node_modules/.bin/cbmp -d "svg" -o "bitmaps/${themeName}" -bc "${baseColor}" -oc "${outlineColor}" -wc "${watchBackgroundColor}"
    else
      ./node_modules/.bin/cbmp -d "svg" -o "bitmaps/${themeName}" -bc "${baseColor}" -oc "${outlineColor}"
    fi

    echo "Rendering complete. Building XCursor theme..."

    echo "4. Build the final cursors"
    ctgen configs/right/x.build.toml -s ${cursorSizes} -p x11 -d "bitmaps/${themeName}" -n "${themeName}" -c "${themeName} cursors"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r themes/${themeName} $out/share/icons/

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Custom colored Bibata Cursor theme built from source";
    homepage = "https://github.com/ful1e5/Bibata_Cursor";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
