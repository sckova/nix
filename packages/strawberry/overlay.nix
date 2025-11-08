final: prev: {
  strawberry-master = prev.callPackage (builtins.path { path = ./package.nix; }) { };
}
