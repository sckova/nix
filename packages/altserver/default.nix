{
  stdenv,
  fetchurl,
  lib,
}: let
  sources = {
    x86_64-linux = {
      arch = "x86_64";
      hash = "sha256-C+fDrcaewRd6FQMrO443xdDk/vtHycQ5zWLCOLPqF/s=";
    };
    i686-linux = {
      arch = "i586";
      hash = "sha256-xxucxefmFOiZn6fgAnKZ6yzxcG+mSpXvLzxlli493EI=";
    };
    aarch64-linux = {
      arch = "aarch64";
      hash = "sha256-iGAgqkS1DTgiUgUZZ9bsSsNfWggjSIem+Mluc6Xz3ik=";
    };
    armv7l-linux = {
      arch = "armv7";
      hash = "sha256-99olJlOMEMbZtFILpSRumZUj146IcyD3HrM5AimZPbg=";
    };
  };

  source = sources.${stdenv.hostPlatform.system};
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "altserver-linux";
    version = "0.0.5";

    src = fetchurl {
      url = "https://github.com/NyaMisty/AltServer-Linux/releases/download/v${finalAttrs.version}/AltServer-${source.arch}";
      hash = source.hash;
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp $src $out/bin/alt-server
      chmod u+x $out/bin/alt-server
      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/NyaMisty/AltServer-Linux";
      description = "AltServer for AltStore, but on-device. Requires root privileges as well as running a custom anisette server currently";
      license = lib.licenses.agpl3Only;
      mainProgram = "alt-server";
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      platforms = ["x86_64-linux" "i686-linux" "aarch64-linux" "armv7l-linux"];
      maintainers = with lib.maintainers; [max-amb];
    };
  })
