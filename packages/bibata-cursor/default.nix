{
  pkgs ? import <nixpkgs> { },
  baseColor ? "#000000",
  cursorSizes ? "24",
  outlineColor ? "#FFFFFF",
  themeName ? "bibata",
}:

let
  src = pkgs.fetchFromGitHub {
    hash = "sha256-kIKidw1vditpuxO1gVuZeUPdWBzkiksO/q2R/+DUdEc=";
    owner = "ful1e5";
    repo = "Bibata_Cursor";
    rev = "v${version}";
  };
  version = "2.0.7";
  yarnOfflineCache = pkgs.fetchYarnDeps {
    hash = "sha256-EpWIGoFFokmzRML2r/dCM+TImOCtii8mifLgnLKdUMY=";
    yarnLock = "${src}/yarn.lock";
  };

in
pkgs.stdenv.mkDerivation {
  inherit version src;

  buildInputs = with pkgs; [
    # Required to satisfy dynamic linking for prebuilt JS native modules (like resvg-js)
    stdenv.cc.cc.lib
  ];

  buildPhase = /* bash */ ''
    runHook preBuild

    ./node_modules/.bin/cbmp -d "svg" -o "bitmaps/${themeName}" -bc "${baseColor}" -oc "${outlineColor}"
    ctgen configs/normal/x.build.toml -s ${cursorSizes} -p x11 -d "bitmaps/${themeName}" -n "${themeName}" -c "${themeName} cursors"

    runHook postBuild
  '';

  configurePhase = /* bash */ ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
    rm -rf node_modules/@resvg/resvg-js-linux-*-musl
    patchShebangs node_modules/
    autoPatchelf node_modules/
    # https://github.com/ful1e5/cbmp/issues/4
    sed -i 's/this.#isEnabled = .*/this.#isEnabled = false;/g' node_modules/ora/index.js

    runHook postConfigure
  '';

  installPhase = /* bash */ ''
    runHook preInstall

    install -dm 0755 $out/share/icons
    cp -r themes/${themeName} $out/share/icons/

    runHook postInstall
  '';

  nativeBuildInputs = with pkgs; [
    yarn
    nodejs
    fixup-yarn-lock
    python3Packages.clickgen
    autoPatchelfHook
  ];

  pname = "bibata-${themeName}-cursor";

  meta = with pkgs.lib; {
    description = "Custom colored Bibata Cursor theme built from source";
    homepage = "https://github.com/ful1e5/Bibata_Cursor";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
