final: prev: {
  spotify-webapp = prev.callPackage (builtins.path {path = ./spotify/package.nix;}) {};
  linux-asahi = prev.callPackage (builtins.path {path = ./linux-fairydust/package.nix;}) {};
}
