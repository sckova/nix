{
  lib,
  stdenv,
  fetchYarnDeps,
  yarn,
  nodejs,
  fixup-yarn-lock,
  nodePackages,
  catppuccin-discord-git,
}:
stdenv.mkDerivation rec {
  pname = "catppuccin-discord";
  version = "unstable-${catppuccin-discord-git.date}-${catppuccin-discord-git.version}";

  src = catppuccin-discord-git.src;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-BhE3aKyA/LBErjWx+lbEVb/CIXhqHkXbV+9U2djIBhs=";
  };

  nativeBuildInputs = [
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
    mkdir -p $out/share/catppuccin-discord
    cp -r dist/dist/* $out/share/catppuccin-discord/
  '';

  meta = {
    description = "Soothing pastel theme for Discord";
    homepage = "https://github.com/catppuccin/discord";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
