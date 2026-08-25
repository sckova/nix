# packages/overlay.nix
{ inputs, isLinux }:

with inputs;
(
  if isLinux then
    [
      noctalia.overlays.default
    ]
  else
    [ ]
)
++ [
  nur.overlays.default
  pedantix.overlays.default
  fh.overlays.default
  (final: prev: {
    inherit (prev.lixPackageSets.stable)
      nixpkgs-review
      nix-eval-jobs
      nix-fast-build
      colmena
      ;

    bibata-cursor = final.callPackage ./bibata-cursor { };
    # linux-asahi = final.callPackage ./linux-asahi { inherit kernel-asahi; };
    mkxp-z = final.callPackage ./mkxp-z { };

    openmw-unstable = prev.openmw.overrideAttrs (oldAttrs: {
      pname = "openmw";
      src = openmw;
      version = "${openmw.rev}";
    });

    spotify-webapp = final.callPackage ./spotify-webapp { };
    yabd = final.python3Packages.callPackage ./yabd { };
  })
]
