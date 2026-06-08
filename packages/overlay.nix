inputs: final: prev: {
  inherit (prev.lixPackageSets.stable)
    nixpkgs-review
    nix-eval-jobs
    nix-fast-build
    colmena
    ;

  spotify-webapp = final.callPackage ./spotify-webapp { };
  bibata-cursor = final.callPackage ./bibata-cursor { };
  mkxp-z = final.callPackage ./mkxp-z { };
  openmw-unstable = prev.openmw.overrideAttrs (oldAttrs: {
    pname = "openmw";
    src = inputs.openmw;
    version = "${inputs.openmw.rev}";
  });

  # remove when https://github.com/NixOS/nixpkgs/pull/525720 is merged
  firefoxpwa = prev.firefoxpwa.overrideAttrs (oldAttrs: {
    buildCommand = ''
      mkdir -p $out/lib/firefoxpwa
    ''
    + (oldAttrs.buildCommand or "");
  });
}
