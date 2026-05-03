final: prev: {
  spotify-webapp = final.callPackage ./spotify-webapp { };
  bibata-cursor = final.callPackage ./bibata-cursor { };

  openmw-unstable = prev.openmw.overrideAttrs (oldAttrs: {
    pname = "openmw";
    src = final.openmw-git;
    version = "${final.openmw-git.rev}";
  });
}
