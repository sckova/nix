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
  fh.overlays.default
  (final: prev: {
    bibata-cursor = final.callPackage ./bibata-cursor { };
    # linux-asahi = final.callPackage ./linux-asahi { inherit kernel-asahi; };
    mkxp-z = final.callPackage ./mkxp-z { };
    opengoal = final.callPackage ./opengoal { };
    opengoal-launcher = final.callPackage ./opengoal-launcher { };

    openmw-unstable = prev.openmw.overrideAttrs (oldAttrs: {
      pname = "openmw";
      src = openmw;
      version = "${openmw.rev}";
    });

    spotify-webapp = final.callPackage ./spotify-webapp { };
    yabd = final.python3Packages.callPackage ./yabd { };
  })
]
