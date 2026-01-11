final: prev: {
  spotify-webapp = prev.callPackage (builtins.path {path = ./spotify/package.nix;}) {};
}
