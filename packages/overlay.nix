final: prev: {
  inherit (prev.lixPackageSets.stable)
    nixpkgs-review
    nix-eval-jobs
    nix-fast-build
    colmena
    ;

  spotify-webapp = final.callPackage ./spotify-webapp { };
  bibata-cursor = final.callPackage ./bibata-cursor { };

  openmw-unstable = prev.openmw.overrideAttrs (oldAttrs: {
    pname = "openmw";
    src = final.openmw-git;
    version = "${final.openmw-git.rev}";
  });
}
