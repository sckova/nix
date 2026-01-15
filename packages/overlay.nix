final: prev: {
  spotify-webapp = final.callPackage ./spotify-webapp {};
  linux-asahi = final.callPackage ./linux-asahi {};
  altserver-linux = final.callPackage ./altserver {};
}
