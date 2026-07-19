inputs: final: prev: {
  inherit (prev.lixPackageSets.stable)
    nixpkgs-review
    nix-eval-jobs
    nix-fast-build
    colmena
    ;

  bibata-cursor = final.callPackage ./bibata-cursor { };
  mkxp-z = final.callPackage ./mkxp-z { };

  openmw-unstable = prev.openmw.overrideAttrs (oldAttrs: {
    pname = "openmw";
    src = inputs.openmw;
    version = "${inputs.openmw.rev}";
  });

  spotify-webapp = final.callPackage ./spotify-webapp { };
}
