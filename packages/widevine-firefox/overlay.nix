final: prev: {
  widevine-firefox = prev.callPackage (builtins.path { path = ./package.nix; }) { };
}
