final: prev: {
  helium-browser = prev.callPackage (builtins.path { path = ./package.nix; }) { };
}
