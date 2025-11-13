final: prev: {
  widevine-helium =
    if prev.stdenv.hostPlatform.system == "aarch64-linux" then
      prev.callPackage ./helium-browser/widevine-aarch64-linux.nix { }
    else
      null;

  helium-browser = prev.callPackage (builtins.path { path = ./helium-browser/package.nix; }) { };

  strawberry-master = prev.callPackage (builtins.path {
    path = ./strawberry/package.nix;
  }) { };

  widevine-firefox = prev.callPackage (builtins.path { path = ./widevine-firefox/package.nix; }) { };
}
